import 'package:fpdart/fpdart.dart';
import 'package:spacemate/core/error/failures.dart';
import 'package:spacemate/core/usecases/usecase.dart';
import 'package:spacemate/features/menu/domain/entities/menu_item_entity.dart';
import 'package:spacemate/features/menu/domain/repositories/menu_repository.dart';

/// Use case for getting menu items
/// 
/// This use case coordinates getting menu items, handling the business logic
/// of when to fetch from remote vs local storage.
class GetMenuItems implements UseCase<List<MenuItemEntity>, GetMenuItemsParams> {
  final MenuRepository repository;

  const GetMenuItems(this.repository);

  @override
  TaskEither<Failure, List<MenuItemEntity>> call(GetMenuItemsParams params) {
    return repository.getMenuItems(
      placeId: params.placeId,
      category: params.category ?? 'home', // Provide a default category
      forceRefresh: params.forceRefresh,
      locale: params.locale,
    );
  }
}

/// Parameters for the [GetMenuItems] use case
class GetMenuItemsParams {
  /// The ID of the place to fetch menu items for
  final String placeId;
  
  /// The category of menu items to fetch
  final String? category;
  
  /// Whether to force a refresh from the remote data source
  final bool forceRefresh;
  
  /// Optional locale for localized content
  final String? locale;

  const GetMenuItemsParams({
    required this.placeId,
    this.category,
    this.forceRefresh = false,
    this.locale,
  });
}
