import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spacemate/features/menu/data/models/menu_item_model.dart';

class MenuItemModelAdapter {
  static const _menuItemsKey = 'menu_items';

  // Normalize id values (accepts int or numeric String) to an int for safe comparisons
  int? _normalizeId(dynamic id) {
    if (id == null) return null;
    if (id is int) return id;
    if (id is String) return int.tryParse(id);
    return null;
  }

  Future<void> saveMenuItem(MenuItemModel menuItem) async {
    final prefs = await SharedPreferences.getInstance();
    final menuItems = await getMenuItems();
    final newId = _normalizeId(menuItem.id);
    final updatedMenuItems = menuItems
        .where((item) => _normalizeId(item.id) != newId)
        .toList()
      ..add(menuItem);
    // Persist as JSON map list
    final encoded = jsonEncode(updatedMenuItems.map((m) => m.toJson()).toList());
    await prefs.setString(_menuItemsKey, encoded);
  }

  /// Accepts either an int or a string representation of an id. Attempts to parse string ids.
  Future<MenuItemModel?> getMenuItem(Object? id) async {
  final int? parsedId = _normalizeId(id);
    if (parsedId == null) return null;
    final menuItems = await getMenuItems();
    try {
      return menuItems.firstWhere((item) => item.id == parsedId);
    } catch (e) {
      return null;
    }
  }

  Future<List<MenuItemModel>> getMenuItems() async {
    final prefs = await SharedPreferences.getInstance();
    final menuItemsJson = prefs.getString(_menuItemsKey);
    if (menuItemsJson == null) return [];
  final menuItemsList = jsonDecode(menuItemsJson) as List<dynamic>;
  return menuItemsList
    .map((item) => MenuItemModel.fromJson(item as Map<String, dynamic>))
    .toList();
  }

  /// Delete by numeric id or string id
  Future<void> deleteMenuItem(Object? id) async {
    final prefs = await SharedPreferences.getInstance();
  final menuItems = await getMenuItems();
  final int? parsedId = _normalizeId(id);
  final updatedMenuItems = parsedId == null
    ? menuItems
    : menuItems.where((item) => _normalizeId(item.id) != parsedId).toList();
    await prefs.setString(
      _menuItemsKey,
      jsonEncode(updatedMenuItems.map((m) => m.toJson()).toList()),
    );
  }

  Future<void> clearMenuItems() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_menuItemsKey);
  }
}
