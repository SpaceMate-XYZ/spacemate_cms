import 'package:spacemate/core/error/exceptions.dart';
import 'package:spacemate/features/menu/domain/entities/menu_item_entity.dart';

abstract class MenuLocalDataSource {
  /// Gets the cached [List<MenuItemEntity>] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<List<MenuItemEntity>> getCachedMenuItems(String slug);

  /// Caches the provided [List<MenuItemEntity>] to be retrieved later.
  ///
  /// Throws [CacheException] if the data cannot be cached.
  Future<void> cacheMenuItems(List<MenuItemEntity> menuItems, String slug);

  /// Clears all cached menu items.
  ///
  /// Throws [CacheException] if the cache cannot be cleared.
  Future<void> clearCachedMenuItems();

  /// Checks if the cache is valid (not expired).
  ///
  /// Returns `true` if the cache is still valid, `false` otherwise.
  Future<bool> isCacheValid(String slug, {Duration maxAge = const Duration(hours: 1)});
}
