import 'package:hive/hive.dart';
import 'package:spacemate/core/error/exceptions.dart';
import 'package:spacemate/features/menu/data/models/menu_item_model.dart';

const String _menuItemsBox = 'menu_items';
const String _cacheTimeKey = 'cache_time';

class MenuLocalDataSourceImpl implements MenuLocalDataSource {
  final Box<dynamic> box;

  MenuLocalDataSourceImpl({required this.box});

  @override
  Future<List<MenuItemModel>> getCachedMenuItems({
    required String placeId,
    required String category,
  }) async {
    try {
      final cacheKey = _getCacheKey(placeId, category);
      final cachedData = box.get(cacheKey);
      
      if (cachedData == null || cachedData is! List) {
        throw const CacheException('No cached data found');
      }

      return cachedData.cast<MenuItemModel>().toList();
    } on HiveError catch (e) {
      throw CacheException('Failed to get cached menu items: ${e.message}');
    } catch (e) {
      throw const CacheException('Failed to get cached menu items');
    }
  }

  @override
  Future<void> cacheMenuItems({
    required String placeId,
    required String category,
    required List<MenuItemModel> items,
  }) async {
    try {
      final cacheKey = _getCacheKey(placeId, category);
      await box.put(cacheKey, items);
      
      // Store the cache time
      final cacheTimeKey = '${_getCacheKey(placeId, category)}_time';
      await box.put(cacheTimeKey, DateTime.now().millisecondsSinceEpoch);
    } on HiveError catch (e) {
      throw CacheException('Failed to cache menu items: ${e.message}');
    } catch (e) {
      throw const CacheException('Failed to cache menu items');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await box.clear();
    } on HiveError catch (e) {
      throw CacheException('Failed to clear cache: ${e.message}');
    } catch (e) {
      throw const CacheException('Failed to clear cache');
    }
  }

  @override
  Future<bool> isCacheValid({
    required String placeId,
    required String category,
    Duration maxAge = const Duration(hours: 1),
  }) async {
    try {
      final cacheTimeKey = '${_getCacheKey(placeId, category)}_time';
      final cacheTime = box.get(cacheTimeKey);
      
      if (cacheTime == null) return false;
      
      final cacheDateTime = DateTime.fromMillisecondsSinceEpoch(cacheTime as int);
      final now = DateTime.now();
      
      return now.difference(cacheDateTime) <= maxAge;
    } catch (e) {
      return false;
    }
  }

  String _getCacheKey(String placeId, String category) {
    return '${_menuItemsBox}_${placeId}_$category';
  }
}
