import 'package:fpdart/fpdart.dart';
import 'package:spacemate/core/error/exceptions.dart';
import 'package:spacemate/core/error/failures.dart';
import 'package:spacemate/core/network/network_info.dart';
import 'package:spacemate/features/menu/data/datasources/menu_local_data_source.dart';
import 'package:spacemate/features/menu/data/datasources/menu_remote_data_source.dart';
import 'package:spacemate/features/menu/domain/entities/menu_item_entity.dart';
import 'package:spacemate/features/menu/domain/repositories/menu_repository.dart';

class MenuRepositoryImpl implements MenuRepository {
  final MenuRemoteDataSource remoteDataSource;
  final MenuLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  MenuRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  TaskEither<Failure, List<MenuItemEntity>> getMenuItems({
    required String slug,
    bool forceRefresh = false,
    String? locale,
  }) {
    return TaskEither.tryCatch(
      () async {
        if (forceRefresh) {
          return await _fetchAndCache(slug: slug, locale: locale);
        }

        try {
          final localItems = await localDataSource.getCachedMenuItems(slug);
          return localItems;
        } on CacheException {
          return await _fetchAndCache(slug: slug, locale: locale);
        }
      },
      (error, stackTrace) {
        if (error is Failure) {
          return error;
        }
        if (error is ServerException) {
          return ServerFailure(error.message);
        }
        if (error is NetworkException) {
          return NetworkFailure(error.message);
        }
        if (error is CacheException) {
          return CacheFailure(error.message);
        }
        return ServerFailure('An unexpected error occurred: $error');
      },
    );
  }

  Future<List<MenuItemEntity>> _fetchAndCache({
    required String slug,
    String? locale,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteItems = await remoteDataSource.getMenuItems(slug: slug, locale: locale);
        await localDataSource.cacheMenuItems(slug: slug, items: remoteItems);
        return remoteItems;
      } on ServerException catch (e) {
        throw ServerFailure(e.message);
      }
    } else {
      throw NetworkFailure('You are offline. Please check your connection.');
    }
  }

  @override
  TaskEither<Failure, List<String>> getSupportedLocales() {
    return TaskEither.left(ServerFailure('This feature is no longer supported.'));
  }
}
