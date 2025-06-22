import 'package:spacemate/features/menu/data/models/menu_item_model.dart';

abstract class MenuLocalDataSource {
  Future<List<MenuItemModel>> getCachedMenuItems({
    required String placeId,
    required String category,
  });

  Future<void> cacheMenuItems({
    required String placeId,
    required String category,
    required List<MenuItemModel> items,
  });

  Future<void> clearCache();

  Future<bool> isCacheValid({
    required String placeId,
    required String category,
    Duration maxAge = const Duration(hours: 1),
  });
}
