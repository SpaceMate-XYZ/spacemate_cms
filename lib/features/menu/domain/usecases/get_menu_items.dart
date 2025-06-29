import 'package:dartz/dartz.dart';
import 'package:spacemate/core/error/failures.dart';
import 'package:spacemate/core/usecases/usecase.dart';
import 'package:spacemate/features/menu/domain/entities/menu_item_entity.dart';
import 'package:spacemate/features/menu/domain/repositories/menu_repository.dart';

/// Use case for getting menu items for a specific screen slug.
class GetMenuItems implements UseCase<List<MenuItemEntity>, GetMenuItemsParams> {
  final MenuRepository repository;

  const GetMenuItems(this.repository);

  @override
  Future<Either<Failure, List<MenuItemEntity>>> call(GetMenuItemsParams params) async {
    return await repository.getMenuItems(placeId: params.placeId);
  }
}

/// Parameters for the [GetMenuItems] use case.
class GetMenuItemsParams {
  /// The slug of the screen to fetch menu items for.
  final String? placeId;

  const GetMenuItemsParams({this.placeId});
}
