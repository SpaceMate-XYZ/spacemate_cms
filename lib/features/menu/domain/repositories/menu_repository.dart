import 'package:fpdart/fpdart.dart';
import 'package:spacemate/core/error/failures.dart';
import 'package:spacemate/features/menu/domain/entities/menu_item_entity.dart';

/// A repository interface for menu-related data operations.
abstract class MenuRepository {
  /// Fetches menu items for a given screen slug, coordinating between
  /// remote and local data sources.
  ///
  /// - [slug]: The slug of the screen to fetch.
  /// - [forceRefresh]: If true, bypasses the cache and fetches from the remote source.
  /// - [locale]: The locale for which to fetch the menu items.
  ///
  /// Returns a [TaskEither] that resolves to either a [Failure] or a list of [MenuItemEntity].
  TaskEither<Failure, List<MenuItemEntity>> getMenuItems({
    required String slug,
    bool forceRefresh = false,
    String? locale,
  });
}
