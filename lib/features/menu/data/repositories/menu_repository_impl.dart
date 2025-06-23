import 'package:fpdart/fpdart.dart';
import 'package:spacemate/core/error/exceptions.dart';
import 'package:spacemate/core/error/failures.dart';
import 'package:spacemate/core/network/network_info.dart';
import 'package:spacemate/features/menu/domain/repositories/menu_local_data_source.dart';
import 'package:spacemate/features/menu/data/datasources/menu_remote_data_source.dart';
import 'package:flutter/foundation.dart';
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
        if (!forceRefresh) {
          final isCacheValid = await localDataSource.isCacheValid(slug);
          if (isCacheValid) {
            try {
              final localItems = await localDataSource.getCachedMenuItems(slug);
              if (localItems.isNotEmpty) {
                return localItems;
              }
            } on CacheException {
              // Fall through to fetch from remote
            }
          }
        }
        // Fetch from remote if cache is invalid, empty, or refresh is forced
        return await _fetchAndCache(slug: slug, locale: locale);
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
    if (kIsWeb || await networkInfo.isConnected) {
      try {
        final remoteScreens = await remoteDataSource.getMenuItems(slug: slug, locale: locale);
        final screen = remoteScreens.firstWhere(
          (s) => s.slug == slug,
          orElse: () => throw ServerException('Screen with slug "$slug" not found in API response.'),
        );
        final itemsToCache = screen.menuGrid;
        await localDataSource.cacheMenuItems(itemsToCache, slug);
        return itemsToCache;
      } on ServerException catch (e) {
        throw e; // Re-throw ServerException to be caught by TaskEither.tryCatch
      }
    } else {
      throw NetworkException('You are offline. Please check your connection.'); // Throw NetworkException
    }
  }

  @override
  TaskEither<Failure, List<String>> getSupportedLocales() {
    return TaskEither.left(const ServerFailure('This feature is no longer supported.'));
  }
}
