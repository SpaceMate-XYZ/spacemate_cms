import 'package:fpdart/fpdart.dart';
import 'package:spacemate/core/error/failures.dart';
import 'package:spacemate/features/menu/domain/entities/menu_item_entity.dart';

/// A repository interface for menu-related data operations
/// 
/// This repository handles all menu-related data operations, including
/// fetching menu items and supported locales.
/// 
/// All methods return [TaskEither] to handle asynchronous operations
/// with functional error handling.
abstract class MenuRepository {
  /// Fetches menu items either from remote or local storage
  /// 
  /// - [placeId]: The ID of the place to fetch menu items for
  /// - [category]: The category of menu items to fetch
  /// - [forceRefresh]: If true, forces a refresh from the remote data source
  /// - [locale]: Optional locale to fetch localized content
  /// 
  /// Returns a [TaskEither] that will resolve to either a [Failure] or a list of [MenuItemEntity]
  TaskEither<Failure, List<MenuItemEntity>> getMenuItems({
    required String placeId,
    required String category,
    bool forceRefresh = false,
    String? locale,
  });

  /// Fetches the list of supported locales for a given place
  /// 
  /// - [placeId]: The ID of the place to fetch supported locales for
  /// 
  /// Returns a [TaskEither] that will resolve to either a [Failure] or a list of locale strings
  TaskEither<Failure, List<String>> getSupportedLocales({
    required String placeId,
  });
}
