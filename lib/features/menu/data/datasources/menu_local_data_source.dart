import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:spacemate/core/database/database_helper.dart';
import 'package:spacemate/core/error/exceptions.dart';
import 'package:spacemate/features/menu/data/models/menu_item_model.dart';
import 'package:spacemate/features/menu/domain/entities/menu_item_entity.dart';
import 'package:spacemate/features/menu/domain/repositories/menu_local_data_source.dart';

class MenuLocalDataSourceImpl implements MenuLocalDataSource {
  final DatabaseHelper dbHelper;

  static const String _menuItemsTable = 'menu_items';
  static const String _cacheMetaTable = 'cache_metadata';

  MenuLocalDataSourceImpl({required this.dbHelper});

  @override
  Future<List<MenuItemEntity>> getCachedMenuItems(String slug) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString('menu_cache_data_$slug');
      if (jsonString == null) {
        print('Web cache: No cached data found for slug: $slug. Returning empty list.');
        return [];
      }
      try {
        final List decoded = json.decode(jsonString);
        return decoded.map((json) => MenuItemModel.fromJson(json)).toList();
      } catch (e) {
        print('Web cache: Error decoding cache for slug: $slug. Returning empty list.');
        return [];
      }
    }
    final db = await dbHelper.database;
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        _menuItemsTable,
        where: 'slug = ?',
        whereArgs: [slug],
        orderBy: '"order" ASC',
      );

      if (maps.isEmpty) {
        print('SQLite Cache: No cached data found for slug: $slug. Returning empty list.');
        return [];
      }
      print('SQLite Cache: Successfully retrieved ${maps.length} items for slug: $slug');
      return maps.map((json) => MenuItemModel.fromJson(json)).toList();
    } catch (e) {
      print('SQLite Cache Retrieval Error: $e. Returning empty list.');
      return [];
    }
  }

  @override
  @override
  Future<void> cacheMenuItems(List<MenuItemEntity> menuItems, String slug) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = menuItems.map((item) {
        if (item is MenuItemModel) {
          return item.toJson();
        } else {
          print('Warning: Attempted to cache non-MenuItemModel item: $item');
          return null;
        }
      }).where((e) => e != null).toList();
      await prefs.setString('menu_cache_data_$slug', json.encode(jsonList));
      // Also cache the timestamp
      final meta = {'timestamp': DateTime.now().millisecondsSinceEpoch};
      await prefs.setString('menu_cache_meta_$slug', json.encode(meta));
      print('Web cache: Successfully cached ${jsonList.length} items for slug: $slug');
      return;
    }
    final db = await dbHelper.database;
    try {
      final batch = db.batch();

      batch.delete(_menuItemsTable, where: 'slug = ?', whereArgs: [slug]);

      for (final item in menuItems) {
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
        print('SQLite Cache: Successfully cached ${menuItems.length} items for slug: $slug');
      } catch (e) {
        print('SQLite Cache Error: $e');
        throw CacheException('Failed to cache menu items: $e');
      }
    } catch (e) {
      throw const CacheException('Failed to cache menu items.');
    }
  }

  @override
  Future<void> clearCachedMenuItems() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys().where((k) => k.startsWith('menu_cache_data_') || k.startsWith('menu_cache_meta_')).toList();
      for (final key in keys) {
        await prefs.remove(key);
      }
      print('Web cache: Cleared all menu cache keys.');
      return;
    }
    await clearCache();
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
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final metaString = prefs.getString('menu_cache_meta_$slug');
      if (metaString == null) return false;

      final meta = json.decode(metaString);
      final lastUpdate = DateTime.fromMillisecondsSinceEpoch(meta['timestamp'] as int);
      return DateTime.now().difference(lastUpdate) <= maxAge;
    }
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
