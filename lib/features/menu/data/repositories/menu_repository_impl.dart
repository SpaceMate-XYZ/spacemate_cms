import 'package:dartz/dartz.dart';
import 'package:spacemate/core/error/failures.dart';
import 'package:spacemate/core/network/network_info.dart';
import 'package:spacemate/features/menu/domain/repositories/menu_local_data_source.dart';
import 'package:spacemate/features/menu/data/datasources/menu_remote_data_source.dart';
import 'package:spacemate/features/menu/data/models/menu_item_model.dart';
import 'package:spacemate/features/menu/domain/entities/menu_item_entity.dart';
import 'package:spacemate/features/menu/domain/repositories/menu_repository.dart';
import 'dart:developer' as developer;

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
  Future<Either<Failure, List<MenuItemEntity>>> getMenuItems({
    String? placeId,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        developer.log('MenuRepositoryImpl: Fetching menu items for placeId: $placeId');
        final result = await remoteDataSource.getMenuItems(placeId: placeId);
        return result.fold(
          (failure) => Left(failure),
          (screenModels) {
            developer.log('MenuRepositoryImpl: Received ${screenModels.length} screen models');
            
            // Since we're filtering by slug, we should only get one screen
            // But handle the case where we might get multiple screens
            if (screenModels.isEmpty) {
              developer.log('MenuRepositoryImpl: No screen models found');
              return const Right(<MenuItemEntity>[]);
            }
            
            // Get the first screen (should be the only one when filtering by slug)
            final screen = screenModels.first;
            developer.log('MenuRepositoryImpl: Processing screen: ${screen.name} (slug: ${screen.slug})');
            developer.log('MenuRepositoryImpl: Screen has ${screen.menuGrid.length} menu items');
            
            // Log all menu items for debugging
            for (int i = 0; i < screen.menuGrid.length; i++) {
              final item = screen.menuGrid[i];
              developer.log('MenuRepositoryImpl: Menu item $i - Label: "${item.label}", Icon: "${item.icon}", NavigationTarget: "${item.navigationTarget}"');
            }
            
            // Convert only this screen's menu grid to MenuItemEntity
            final menuItems = screen.menuGrid
                .map((item) => MenuItemModel.fromJson(item.toJson()))
                .toList();
            
            developer.log('MenuRepositoryImpl: Converted to ${menuItems.length} menu item entities');
            return Right(menuItems);
          },
        );
      } else {
        // Try to get from local cache
        final cachedItems = await localDataSource.getMenuItems(placeId: placeId);
        if (cachedItems.isNotEmpty) {
          return Right(cachedItems);
        } else {
          return const Left(NetworkFailure('No internet connection and no cached data'));
        }
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getSupportedLocales({
    String? placeId,
  }) async {
    // This feature is no longer supported
    return const Left(ServerFailure('This feature is no longer supported.'));
  }
}
