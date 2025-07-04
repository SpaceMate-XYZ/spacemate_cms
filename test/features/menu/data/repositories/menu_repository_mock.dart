import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spacemate/core/error/failures.dart';
import 'package:spacemate/features/menu/domain/entities/menu_item_entity.dart';
import 'package:spacemate/features/menu/domain/repositories/menu_repository.dart';

class MockMenuRepository extends Mock implements MenuRepository {
  @override
  Future<Either<Failure, List<MenuItemEntity>>> getMenuItems({
    String? placeId,
  }) async {
    return const Right([
      MenuItemEntity(
        id: 1,
        label: 'Dashboard',
        icon: 'dashboard',
        order: 1,
        isVisible: true,
        isAvailable: true,
        badgeCount: null,
      ),
    ]);
  }

  @override
  Future<Either<Failure, List<String>>> getSupportedLocales({
    String? placeId,
  }) async {
    return const Right(['en', 'es']);
  }
}
