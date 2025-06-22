import 'package:dio/dio.dart';
import 'package:spacemate/features/menu/data/models/menu_item_model.dart';

import 'package:fpdart/fpdart.dart';
import 'package:spacemate/core/error/failures.dart';
import 'package:spacemate/features/menu/data/models/menu_item_model.dart';

/// Data source contract for remote menu data operations
/// 
/// This interface defines the contract for fetching menu data from a remote source.
/// All methods return [Future] as they perform asynchronous network operations.
abstract class MenuRemoteDataSource {
  /// Fetches menu items from the remote data source
  /// 
  /// - [placeId]: The ID of the place to fetch menu items for
  /// - [category]: The category of menu items to fetch
  /// - [locale]: Optional locale to fetch localized content
  /// - [cancelToken]: Optional token to cancel the request
  /// 
  /// Returns a [Future] that resolves to a list of [MenuItemModel]
  Future<List<MenuItemModel>> getMenuItems({
    required String placeId,
    required String category,
    String? locale,
    CancelToken? cancelToken,
  });

  /// Fetches the list of supported locales from the remote data source
  /// 
  /// - [placeId]: The ID of the place to fetch supported locales for
  /// - [cancelToken]: Optional token to cancel the request
  /// 
  /// Returns a [Future] that resolves to a list of locale strings
  Future<List<String>> getSupportedLocales({
    required String placeId,
    CancelToken? cancelToken,
  });
}
