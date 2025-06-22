import 'package:sqflite/sqflite.dart';
import 'package:spacemate/core/database/database_helper.dart';
import 'package:spacemate/core/error/exceptions.dart';
import 'package:spacemate/features/menu/data/models/menu_item_model.dart';
import 'menu_local_data_source.dart';

class MenuLocalDataSourceSqflite implements MenuLocalDataSource {
  final DatabaseHelper dbHelper;

  MenuLocalDataSourceSqflite({required this.dbHelper});

  @override
  Future<List<MenuItemModel>> getCachedMenuItems({
    required String placeId,
    required String category,
  }) async {
    try {
      final db = await dbHelper.database;
      
      final List<Map<String, dynamic>> maps = await db.query(
        'menu_items',
        where: 'category = ?',
        whereArgs: [category],
        orderBy: '"order" ASC',
      );

      return List.generate(maps.length, (i) {
        return MenuItemModel.fromJson(maps[i]);
      });
    } catch (e) {
      throw CacheException('Failed to get cached menu items: $e');
    }
  }

  @override
  Future<void> cacheMenuItems({
    required String placeId,
    required String category,
    required List<MenuItemModel> items,
  }) async {
    final db = await dbHelper.database;
    final batch = db.batch();
    
    // First, delete existing items in this category
    batch.delete(
      'menu_items',
      where: 'category = ?',
      whereArgs: [category],
    );

    // Then insert new items
    for (var item in items) {
      batch.insert('menu_items', item.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }

    try {
      await batch.commit(noResult: true);
    } catch (e) {
      throw CacheException('Failed to cache menu items: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await dbHelper.clearDatabase();
    } catch (e) {
      throw CacheException('Failed to clear cache: $e');
    }
  }

  @override
  Future<bool> isCacheValid({
    required String placeId,
    required String category,
    Duration maxAge = const Duration(hours: 1),
  }) async {
    try {
      final db = await dbHelper.database;
      
      // Get the most recently updated item in this category
      final result = await db.query(
        'menu_items',
        where: 'category = ?',
        whereArgs: [category],
        orderBy: 'updated_at DESC',
        limit: 1,
      );

      if (result.isEmpty) return false;
      
      final lastUpdate = DateTime.fromMillisecondsSinceEpoch(
        result.first['updated_at'] as int,
      );
      
      return DateTime.now().difference(lastUpdate) <= maxAge;
    } catch (e) {
      return false;
    }
  }
}
