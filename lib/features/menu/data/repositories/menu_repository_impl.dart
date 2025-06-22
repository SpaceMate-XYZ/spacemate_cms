import 'package:fpdart/fpdart.dart';

import 'package:spacemate/core/error/exceptions.dart';
import 'package:spacemate/core/error/failures.dart';
import 'package:spacemate/core/network/network_info.dart';
import 'package:spacemate/features/menu/data/datasources/menu_local_data_source.dart';
import 'package:spacemate/features/menu/data/datasources/menu_remote_data_source.dart';
import 'package:spacemate/features/menu/data/models/menu_item_model.dart';
import 'package:spacemate/features/menu/domain/entities/menu_item_entity.dart';
import 'package:spacemate/features/menu/domain/repositories/menu_repository.dart';

/// Extension on Either to add utility methods
extension EitherX<L, R> on Either<L, R> {
  R? get right => fold((_) => null, (r) => r);
  L? get left => fold((l) => l, (_) => null);
  bool get isRight => this is Right<L, R>;
  bool get isLeft => this is Left<L, R>;
}

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
    required String placeId,
    required String category,
    bool forceRefresh = false,
    String? locale,
  }) {
    return TaskEither<Failure, List<MenuItemEntity>>.tryCatch(
      () async {
        if (forceRefresh || !(await networkInfo.isConnected)) {
          final remoteResult = await _getMenuItemsFromRemote(placeId, category, locale, forceRefresh).run();
          return remoteResult.fold(
            (failure) => throw failure,
            (items) => items,
          );
        } else {
          final localResult = await _getMenuItemsFromLocal(placeId, category, forceRefresh).run();
          return localResult.fold(
            (failure) => throw failure,
            (items) => items,
          );
        }
      },
      (error, _) => error is Failure ? error : ServerFailure('An unexpected error occurred'),
    );
  }

  TaskEither<Failure, List<MenuItemEntity>> _getMenuItemsFromRemote(
    String placeId,
    String category,
    String? locale,
    bool forceRefresh,
  ) {
    return TaskEither<Failure, List<MenuItemEntity>>.tryCatch(
      () async {
        if (!(await networkInfo.isConnected)) {
          throw NetworkFailure();
        }
        
        final items = await remoteDataSource.getMenuItems(
          placeId: placeId,
          category: category,
          locale: locale,
        );
        
        await localDataSource.cacheMenuItems(
          placeId: placeId,
          category: category,
          items: items,
        );
        
        return items.map((model) => model.toEntity()).toList();
      },
      (error, _) {
        if (error is ServerException) {
          return ServerFailure(error.message);
        } else if (error is NetworkException) {
          return NetworkFailure(error.message);
        } else if (error is Failure) {
          return error;
        } else {
          return ServerFailure('An unexpected error occurred');
        }
      },
    );
  }

  TaskEither<Failure, List<MenuItemEntity>> _getMenuItemsFromLocal(
    String placeId,
    String category,
    bool forceRefresh,
  ) {
    return TaskEither<Failure, List<MenuItemEntity>>.tryCatch(
      () async {
        if (forceRefresh) {
          throw NetworkFailure('Force refresh required but offline');
        }
        
        final items = await localDataSource.getCachedMenuItems(
          placeId: placeId,
          category: category,
        );
        
        return items.map((model) => model.toEntity()).toList();
      },
      (error, _) {
        if (error is CacheException) {
          return CacheFailure(error.message);
        } else if (error is NetworkException) {
          return NetworkFailure(error.message);
        } else if (error is Failure) {
          return error;
        } else {
          return CacheFailure('Failed to load cached menu items');
        }
      },
    );
  }

  @override
  TaskEither<Failure, List<String>> getSupportedLocales({
    required String placeId,
  }) {
    return TaskEither<Failure, List<String>>.tryCatch(
      () async {
        if (!(await networkInfo.isConnected)) {
          throw NetworkFailure();
        }
        
        return await remoteDataSource.getSupportedLocales(placeId: placeId);
      },
      (error, _) {
        if (error is ServerException) {
          return ServerFailure(error.message);
        } else if (error is NetworkException) {
          return NetworkFailure(error.message);
        } else if (error is Failure) {
          return error;
        } else {
          return ServerFailure('Failed to load supported locales');
        }
      },
    );
  }
}
