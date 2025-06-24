import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spacemate/features/menu/data/models/menu_item_model.dart';

class MenuItemModelAdapter {
  static const _menuItemsKey = 'menu_items';

  Future<void> saveMenuItem(MenuItemModel menuItem) async {
    final prefs = await SharedPreferences.getInstance();
    final menuItems = await getMenuItems();
    final updatedMenuItems = menuItems
        .where((item) => item.id != menuItem.id)
        .toList()
      ..add(menuItem);
    await prefs.setString(_menuItemsKey, jsonEncode(updatedMenuItems));
  }

  Future<MenuItemModel?> getMenuItem(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final menuItems = await getMenuItems();
    try {
      return menuItems.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<MenuItemModel>> getMenuItems() async {
    final prefs = await SharedPreferences.getInstance();
    final menuItemsJson = prefs.getString(_menuItemsKey);
    if (menuItemsJson == null) return [];
    final menuItemsList = jsonDecode(menuItemsJson) as List;
    return menuItemsList.map((item) => MenuItemModel.fromJson(item)).toList();
  }

  Future<void> deleteMenuItem(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final menuItems = await getMenuItems();
    final updatedMenuItems = menuItems.where((item) => item.id != id).toList();
    await prefs.setString(_menuItemsKey, jsonEncode(updatedMenuItems));
  }

  Future<void> clearMenuItems() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_menuItemsKey);
  }
}
