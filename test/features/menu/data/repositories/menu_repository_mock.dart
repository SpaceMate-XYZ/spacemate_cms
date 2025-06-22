import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spacemate/core/error/failures.dart';
import 'package:spacemate/features/menu/domain/entities/menu_item_entity.dart';
import 'package:spacemate/features/menu/domain/repositories/menu_repository.dart';

class MockMenuRepository extends Mock implements MenuRepository {
  @override
  TaskEither<Failure, List<MenuItemEntity>> getMenuItems({
    required String placeId,
    required String category,
    bool forceRefresh = false,
    String? locale,
  }) {
    return super.noSuchMethod(
      Invocation.method(
        #getMenuItems,
        [],
        {
          #placeId: placeId,
          #category: category,
          #forceRefresh: forceRefresh,
          if (locale != null) #locale: locale,
        },
      ),
      returnValue: TaskEither.right([
        MenuItemEntity(
          id: '1',
          title: 'Dashboard',
          icon: 'assets/icons/dashboard.svg',
          route: '/dashboard',
          isActive: true,
          order: 1,
        ),
        MenuItemEntity(
          id: '2',
          title: 'Settings',
          icon: 'assets/icons/settings.svg',
          route: '/settings',
          isActive: true,
          order: 2,
        ),
      ]),
    ) as TaskEither<Failure, List<MenuItemEntity>>;
  }

  @override
  TaskEither<Failure, bool> updateMenuItemOrder({
    required String placeId,
    required List<String> menuItemIds,
  }) {
    return super.noSuchMethod(
      Invocation.method(
        #updateMenuItemOrder,
        [],
        {
          #placeId: placeId,
          #menuItemIds: menuItemIds,
        },
      ),
      returnValue: TaskEither.right(true),
    ) as TaskEither<Failure, bool>;
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
      returnValue: TaskEither.right(['en', 'es']),
    ) as TaskEither<Failure, List<String>>;
  }
}
