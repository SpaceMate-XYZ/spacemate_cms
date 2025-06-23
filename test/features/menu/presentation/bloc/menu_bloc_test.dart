import 'package:bloc_test/bloc_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spacemate/core/error/failures.dart';
import 'package:spacemate/features/menu/domain/entities/menu_category.dart';
import 'package:spacemate/features/menu/domain/entities/menu_item_entity.dart';
import 'package:spacemate/features/menu/domain/repositories/menu_repository.dart';
import 'package:spacemate/features/menu/domain/usecases/get_menu_items.dart';
import 'package:spacemate/features/menu/domain/usecases/get_supported_locales.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_event.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_state.dart';

class MockMenuRepository extends Mock implements MenuRepository {}

void main() {
  late MenuBloc menuBloc;
  late MockMenuRepository mockRepository;
  
  final mockMenuItems = <MenuItemEntity>[
    const MenuItemEntity(
      id: '1',
      title: 'Dashboard',
      icon: 'dashboard',
      category: MenuCategory.home,
      route: '/dashboard',
      isActive: true,
      order: 1,
      analyticsId: 'dashboard',
      requiredPermissions: [],
    ),
    const MenuItemEntity(
      id: '2',
      title: 'Settings',
      icon: 'settings',
      category: MenuCategory.home,
      route: '/settings',
      isActive: true,
      order: 2,
      analyticsId: 'settings',
      requiredPermissions: [],
    ),
  ];

  setUp(() {
    mockRepository = MockMenuRepository();
    menuBloc = MenuBloc(
      getMenuItems: GetMenuItems(mockRepository),
      getSupportedLocales: GetSupportedLocales(mockRepository),
    );
  });

  tearDown(() {
    menuBloc.close();
  });

  group('MenuBloc', () {
    group('LoadMenu', () {
      blocTest<MenuBloc, MenuState>(
        'emits [loading, loaded] when LoadMenu is added and succeeds',
        build: () {
          when(() => mockRepository.getMenuItems(
                placeId: any(named: 'placeId'),
                category: any(named: 'category'),
                forceRefresh: any(named: 'forceRefresh'),
                locale: any(named: 'locale'),
              )).thenAnswer((_) => TaskEither.right(mockMenuItems));
          return menuBloc;
        },
        act: (bloc) => bloc.add(const LoadMenuEvent(
          placeId: 'test_place_id',
          category: 'test_category',
        )),
        expect: () => [
          const MenuState(
            status: MenuStatus.loading,
            placeId: 'test_place_id',
          ),
          MenuState(
            status: MenuStatus.success,
            items: mockMenuItems,
            placeId: 'test_place_id',
            category: 'test_category',
          ),
        ],
      );

      blocTest<MenuBloc, MenuState>(
        'emits [loading, error] when LoadMenu fails',
        build: () {
          when(() => mockRepository.getMenuItems(
                placeId: any(named: 'placeId'),
                category: any(named: 'category'),
                forceRefresh: any(named: 'forceRefresh'),
                locale: any(named: 'locale'),
              )).thenAnswer((_) => TaskEither.left(
                    const ServerFailure('Failed to load menu'),
                  ));
          return menuBloc;
        },
        act: (bloc) => bloc.add(const LoadMenuEvent(
          placeId: 'test_place_id',
          category: 'test_category',
        )),
        expect: () => [
          const MenuState(
            status: MenuStatus.loading,
            placeId: 'test_place_id',
          ),
          const MenuState(
            status: MenuStatus.failure,
            errorMessage: 'Server error',
            placeId: 'test_place_id',
          ),
        ],
      );
    });

    group('ChangeCategory', () {
      blocTest<MenuBloc, MenuState>(
        'emits state with updated category and loads menu items',
        build: () {
          when(() => mockRepository.getMenuItems(
                placeId: 'test_place_id',
                category: 'new_category',
                forceRefresh: false,
                locale: null,
              )).thenAnswer((_) => TaskEither.right(mockMenuItems));
          return menuBloc;
        },
        seed: () => const MenuState(
          placeId: 'test_place_id',
          status: MenuStatus.success,
        ),
        act: (bloc) => bloc.add(const ChangeCategoryEvent('new_category')),
        expect: () => [
          const MenuState(
            status: MenuStatus.loading,
            placeId: 'test_place_id',
          ),
          MenuState(
            status: MenuStatus.success,
            items: mockMenuItems,
            placeId: 'test_place_id',
            category: 'new_category',
          ),
        ],
      );
    });

    group('ChangeLocale', () {
      blocTest<MenuBloc, MenuState>(
        'emits state with updated locale and reloads menu items',
        build: () {
          when(() => mockRepository.getMenuItems(
                placeId: 'test_place_id',
                category: 'test_category',
                forceRefresh: false,
                locale: 'es',
              )).thenAnswer((_) => TaskEither.right(mockMenuItems));
          return menuBloc;
        },
        seed: () => const MenuState(
          placeId: 'test_place_id',
          status: MenuStatus.success,
          category: 'test_category',
        ),
        act: (bloc) => bloc.add(const ChangeLocaleEvent('es')),
        expect: () => [
          const MenuState(
            status: MenuStatus.loading,
            placeId: 'test_place_id',
            category: 'test_category',
            selectedLocale: 'es',
          ),
          MenuState(
            status: MenuStatus.success,
            items: mockMenuItems,
            placeId: 'test_place_id',
            category: 'test_category',
            selectedLocale: 'es',
          ),
        ],
      );
    });
  });
}
