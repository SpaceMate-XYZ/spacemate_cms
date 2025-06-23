import 'package:sqflite/sqflite.dart';
import 'package:spacemate/core/database/database_helper.dart';
import 'package:spacemate/core/error/exceptions.dart';
import 'package:spacemate/features/menu/data/models/menu_item_model.dart';
import 'package:spacemate/features/menu/domain/entities/menu_item_entity.dart';
import 'menu_local_data_source.dart';

class MenuLocalDataSourceImpl implements MenuLocalDataSource {
  final DatabaseHelper dbHelper;

  static const String _menuItemsTable = 'menu_items';
  static const String _cacheMetaTable = 'cache_metadata';

  MenuLocalDataSourceImpl({required this.dbHelper});

  @override
  Future<List<MenuItemEntity>> getCachedMenuItems(String slug) async {
    final db = await dbHelper.database;
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        _menuItemsTable,
        where: 'slug = ?',
        whereArgs: [slug],
        orderBy: '"order" ASC',
      );

      if (maps.isEmpty) {
        print('SQLite Cache: No cached data found for slug: $slug');
        throw const CacheException('No cached data found for this slug.');
      }
      print('SQLite Cache: Successfully retrieved ${maps.length} items for slug: $slug');

      return maps.map((json) => MenuItemModel.fromJson(json)).toList();
    } catch (e) {
      print('SQLite Cache Retrieval Error: $e');
      throw CacheException('Failed to get cached menu items: $e');
    }
  }

  @override
  Future<void> cacheMenuItems({
    required String slug,
    required List<MenuItemEntity> items,
  }) async {
    final db = await dbHelper.database;
    try {
      final batch = db.batch();

      batch.delete(_menuItemsTable, where: 'slug = ?', whereArgs: [slug]);

      for (final item in items) {
        if (item is MenuItemModel) {
          final json = item.toJson()
            ..['slug'] = slug
            ..['cached_at'] = DateTime.now().millisecondsSinceEpoch;
          print('Attempting to cache item: $json');
          batch.insert(_menuItemsTable, json, conflictAlgorithm: ConflictAlgorithm.replace);
        } else {
          print('Warning: Attempted to cache non-MenuItemModel item: $item');
        }
      }

      batch.insert(
        _cacheMetaTable,
        {'slug': slug, 'timestamp': DateTime.now().millisecondsSinceEpoch},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      try {
        await batch.commit(noResult: true);
        print('SQLite Cache: Successfully cached ${items.length} items for slug: $slug');
      } catch (e) {
        print('SQLite Cache Error: $e');
        throw CacheException('Failed to cache menu items: $e');
      }
    } catch (e) {
      throw CacheException('Failed to cache menu items.');
    }
  }

  @override
  Future<void> clearCache() async {
    final db = await dbHelper.database;
    try {
      await db.delete(_menuItemsTable);
      await db.delete(_cacheMetaTable);
      print('SQLite Cache: All cache cleared.');
    } catch (e) {
      print('SQLite Cache Clear Error: $e');
      throw CacheException('Failed to clear cache: $e');
    }
  }

  @override
  Future<bool> isCacheValid(String slug, {Duration maxAge = const Duration(hours: 1)}) async {
    try {
      final db = await dbHelper.database;
      final result = await db.query(
        _cacheMetaTable,
        where: 'slug = ?',
        whereArgs: [slug],
        limit: 1,
      );

      if (result.isEmpty) return false;

      final lastUpdate = DateTime.fromMillisecondsSinceEpoch(result.first['timestamp'] as int);
      return DateTime.now().difference(lastUpdate) <= maxAge;
    } catch (e) {
      return false;
    }
  }
}
