import 'package:dio/dio.dart';
import 'package:spacemate/features/menu/data/models/menu_item_model.dart';

abstract class MenuRemoteDataSource {
  /// Fetches a list of menu items for a given screen slug from the remote server.
  ///
  /// - [slug]: The slug of the screen to fetch.
  /// - [locale]: The locale for which to fetch the menu items.
  /// - [cancelToken]: A token to cancel the request.
  ///
  /// Returns a [Future] that completes with a list of [MenuItemModel].
  /// Throws a [ServerException] if the request fails.
  Future<List<MenuItemModel>> getMenuItems({
    required String slug,
    String? locale,
    CancelToken? cancelToken,
  });
}
