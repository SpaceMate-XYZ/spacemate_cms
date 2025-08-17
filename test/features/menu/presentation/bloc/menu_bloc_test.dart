import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spacemate/core/error/failures.dart';
import 'package:spacemate/features/menu/domain/entities/menu_item_entity.dart';
import 'package:spacemate/features/menu/domain/repositories/menu_repository.dart';
import 'package:spacemate/features/menu/domain/usecases/get_menu_items.dart';
import 'package:spacemate/features/menu/domain/usecases/get_menu_grids_for_user.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_event.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_state.dart';
import 'package:dartz/dartz.dart';

class MockMenuRepository extends Mock implements MenuRepository {}
class MockGetMenuGridsForUser extends Mock implements GetMenuGridsForUser {}

void main() {
  late MenuBloc menuBloc;
  late MockMenuRepository mockRepository;
  late GetMenuItems getMenuItems;
  late GetMenuGridsForUser getMenuGridsForUser;
  
  final mockMenuItems = <MenuItemEntity>[
    const MenuItemEntity(
      id: 1,
      label: 'Dashboard',
      icon: 'dashboard',
      order: 1,
      isVisible: true,
      isAvailable: true,
    ),
    const MenuItemEntity(
      id: 2,  
      label: 'Settings',
      icon: 'settings',
      order: 2,
      isVisible: true,
      isAvailable: true,
    ),
  ];

  setUp(() {
    mockRepository = MockMenuRepository();
    getMenuItems = GetMenuItems(mockRepository);
  getMenuGridsForUser = MockGetMenuGridsForUser();
  menuBloc = MenuBloc(getMenuItems: getMenuItems, getMenuGridsForUser: getMenuGridsForUser);
  });

  tearDown(() {
    menuBloc.close();
  });

  group('MenuBloc', () {
    test('initial state is correct', () {
      expect(menuBloc.state, const MenuState.initial());
    });

    group('LoadMenuEvent', () {
      blocTest<MenuBloc, MenuState>(
        'emits [loading, success] when LoadMenuEvent is added and succeeds',
        build: () {
          when(() => mockRepository.getMenuItems(
                placeId: any(named: 'placeId'),
              )).thenAnswer((_) async => Right(mockMenuItems));
          return menuBloc;
        },
        act: (bloc) => bloc.add(const LoadMenuEvent(slug: 'home')),
        expect: () => [
          const MenuState(
            status: MenuStatus.loading,
            slug: 'home',
            items: [],
          ),
          MenuState(
            status: MenuStatus.success,
            slug: 'home',
            items: mockMenuItems,
          ),
        ],
      );

      blocTest<MenuBloc, MenuState>(
        'emits [loading, failure] when LoadMenuEvent fails',
        build: () {
          when(() => mockRepository.getMenuItems(
                placeId: any(named: 'placeId'),
              )).thenAnswer((_) async => const Left(ServerFailure('Failed to load menu')));
          return menuBloc;
        },
        act: (bloc) => bloc.add(const LoadMenuEvent(slug: 'home')),
        expect: () => [
          const MenuState(
            status: MenuStatus.loading,
            slug: 'home',
            items: [],
          ),
          const MenuState(
            status: MenuStatus.failure,
            slug: 'home',
            items: [],
            errorMessage: 'Failed to load menu',
          ),
        ],
      );

      blocTest<MenuBloc, MenuState>(
        'uses cached items when loading same placeId without forceRefresh',
        build: () {
          when(() => mockRepository.getMenuItems(
                placeId: any(named: 'placeId'),
              )).thenAnswer((_) async => Right(mockMenuItems));
          return menuBloc;
        },
        act: (bloc) async {
          bloc.add(const LoadMenuEvent(slug: 'home'));
          await Future.delayed(const Duration(milliseconds: 100));
          bloc.add(const LoadMenuEvent(slug: 'home')); // Should use cache
        },
        verify: (bloc) {
          verify(() => mockRepository.getMenuItems(
                placeId: 'home',
              )).called(1); // Should only be called once due to caching
        },
      );

      blocTest<MenuBloc, MenuState>(
        'forces refresh when forceRefresh is true',
        build: () {
          when(() => mockRepository.getMenuItems(
                placeId: any(named: 'placeId'),
              )).thenAnswer((_) async => Right(mockMenuItems));
          return menuBloc;
        },
        act: (bloc) async {
          bloc.add(const LoadMenuEvent(slug: 'home'));
          await Future.delayed(const Duration(milliseconds: 100));
          bloc.add(const LoadMenuEvent(slug: 'home', forceRefresh: true));
        },
        verify: (bloc) {
          verify(() => mockRepository.getMenuItems(
                placeId: 'home',
              )).called(2);
        },
      );
    });

    group('RefreshMenuEvent', () {
      blocTest<MenuBloc, MenuState>(
        'triggers LoadMenuEvent with forceRefresh true',
        build: () {
          when(() => mockRepository.getMenuItems(
                placeId: any(named: 'placeId'),
              )).thenAnswer((_) async => Right(mockMenuItems));
          return menuBloc;
        },
        act: (bloc) => bloc.add(const RefreshMenuEvent(slug: 'home')),
        expect: () => [
          const MenuState(
            status: MenuStatus.loading,
            slug: 'home',
            items: [],
          ),
          MenuState(
            status: MenuStatus.success,
            slug: 'home',
            items: mockMenuItems,
          ),
        ],
        verify: (bloc) {
          verify(() => mockRepository.getMenuItems(
                placeId: 'home',
              )).called(1);
        },
      );
    });

    group('getStateForCategory', () {
      test('returns correct state for cached category', () async {
        when(() => mockRepository.getMenuItems(
              placeId: any(named: 'placeId'),
            )).thenAnswer((_) async => Right(mockMenuItems));

        menuBloc.add(const LoadMenuEvent(slug: 'home'));
        await Future.delayed(const Duration(milliseconds: 100));

        final state = menuBloc.getStateForCategory('home');
        expect(state.items, equals(mockMenuItems));
        expect(state.status, equals(MenuStatus.success));
      });

      test('returns empty state for uncached category', () {
        final state = menuBloc.getStateForCategory('uncached');
        expect(state.items, isEmpty);
        expect(state.status, equals(MenuStatus.success));
      });
    });
  });
}
