import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spacemate/core/error/failures.dart';
import 'package:spacemate/features/menu/domain/entities/menu_item_entity.dart';
import 'package:spacemate/features/menu/domain/repositories/menu_repository.dart';

class MockMenuRepository extends Mock implements MenuRepository {
  @override
  TaskEither<Failure, List<MenuItemEntity>> getMenuItems({
    required String slug,
    bool forceRefresh = false,
    String? locale,
  }) {
    return super.noSuchMethod(
      Invocation.method(
        #getMenuItems,
        [],
        {
          #slug: slug,
          #forceRefresh: forceRefresh,
          if (locale != null) #locale: locale,
        },
      ),
    ) ?? TaskEither.right([
      const MenuItemEntity(
        id: 1,
        label: 'Dashboard',
        icon: 'dashboard',
        order: 1,
        isVisible: true,
        isAvailable: true,
        badgeCount: null,
      ),
      const MenuItemEntity(
        id: 2,
        label: 'Settings',
        icon: 'settings',
        order: 2,
        isVisible: true,
        isAvailable: true,
        badgeCount: null,
      ),
    ]);
  }

  @override
  TaskEither<Failure, List<String>> getSupportedLocales({
    required String placeId,
  }) {
    return super.noSuchMethod(
      Invocation.method(
        #getSupportedLocales,
        [],
        {#placeId: placeId},
      ),
    ) ?? TaskEither.right(['en', 'es']);
  }
}
