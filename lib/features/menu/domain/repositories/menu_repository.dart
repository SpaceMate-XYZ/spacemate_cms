import 'package:dartz/dartz.dart';
import 'package:spacemate/core/error/failures.dart';
import 'package:spacemate/features/menu/domain/entities/menu_item_entity.dart';

/// A repository interface for menu-related data operations.
abstract class MenuRepository {
  /// Fetches menu items from the remote data source
  /// 
  /// [placeId] - Optional filter for place-specific menu items
  /// Returns [List<MenuItemEntity>] on success or [Failure] on error
  Future<Either<Failure, List<MenuItemEntity>>> getMenuItems({
    String? placeId,
  });

  /// Fetches supported locales from the remote data source
  /// 
  /// Returns [List<String>] on success or [Failure] on error
  Future<Either<Failure, List<String>>> getSupportedLocales({
    String? placeId,
  });
}
