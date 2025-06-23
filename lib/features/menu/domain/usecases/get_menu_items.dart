import 'package:fpdart/fpdart.dart';
import 'package:spacemate/core/error/failures.dart';
import 'package:spacemate/core/usecases/usecase.dart';
import 'package:spacemate/features/menu/domain/entities/menu_item_entity.dart';
import 'package:spacemate/features/menu/domain/repositories/menu_repository.dart';

/// Use case for getting menu items for a specific screen slug.
class GetMenuItems implements UseCase<List<MenuItemEntity>, GetMenuItemsParams> {
  final MenuRepository repository;

  const GetMenuItems(this.repository);

  @override
  TaskEither<Failure, List<MenuItemEntity>> call(GetMenuItemsParams params) {
    return repository.getMenuItems(
      slug: params.slug,
      forceRefresh: params.forceRefresh,
      locale: params.locale,
    );
  }
}

/// Parameters for the [GetMenuItems] use case.
class GetMenuItemsParams {
  /// The slug of the screen to fetch menu items for.
  final String slug;

  /// Whether to force a refresh from the remote data source.
  final bool forceRefresh;

  /// Optional locale for localized content.
  final String? locale;

  const GetMenuItemsParams({
    required this.slug,
    this.forceRefresh = false,
    this.locale,
  });
}
