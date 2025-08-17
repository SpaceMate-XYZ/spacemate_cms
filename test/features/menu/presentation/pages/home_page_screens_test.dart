import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spacemate/features/menu/domain/entities/menu_item_entity.dart';
import 'package:spacemate/features/menu/domain/entities/screen_entity.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_state.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_event.dart';
import 'package:spacemate/features/menu/presentation/pages/home_page.dart';
import '../../../../../test/helpers/test_setup.dart';
import 'package:spacemate/features/carousel/presentation/bloc/carousel_bloc.dart';

class MockMenuBloc extends Mock implements MenuBloc {}
class MockCarouselBloc extends Mock implements CarouselBloc {}

void main() {
  late MockMenuBloc mockMenuBloc;
  late MockCarouselBloc mockCarouselBloc;

  setUp(() {
  mockMenuBloc = MockMenuBloc();
  // Provide a carousel bloc so CarouselWidget can find its BlocProvider in tests
  mockCarouselBloc = MockCarouselBloc();
  });

  setUpAll(() async {
    // Ensure test DI is initialized so ThemeService and other singletons exist
    await TestSetup.initializeTestDI();
    registerFallbackValue(const LoadMenuGridsEvent(placeId: 'home'));
  });

  Widget createTestWidget(MenuState state) {
    return TestSetup.createTestApp(
      child: const HomePage(),
      menuBloc: mockMenuBloc,
  carouselBloc: mockCarouselBloc,
    );
  }

  testWidgets('renders grid from state.screens when available', (tester) async {
    final screens = [
      const ScreenEntity(
        id: 1,
        name: 'Home Screen',
        slug: 'home',
        title: 'Home',
        menuGrid: [
          MenuItemEntity(id: 1, label: 'A', icon: null, order: 1, isVisible: true, isAvailable: true),
          MenuItemEntity(id: 2, label: 'B', icon: null, order: 2, isVisible: true, isAvailable: true),
        ],
      ),
    ];

  final state = MenuState.success(items: const [], screens: screens);
  when(() => mockMenuBloc.state).thenReturn(state);
  when(() => mockMenuBloc.stream).thenAnswer((_) => Stream<MenuState>.value(state));
  // Stub carousel bloc so CarouselWidget's BlocBuilder can build
  when(() => mockCarouselBloc.state).thenReturn(CarouselInitial());
  when(() => mockCarouselBloc.stream).thenAnswer((_) => Stream<CarouselState>.value(CarouselInitial()));

    await tester.pumpWidget(createTestWidget(MenuState.success(items: const [], screens: screens)));
    await tester.pumpAndSettle();

    expect(find.text('A'), findsOneWidget);
    expect(find.text('B'), findsOneWidget);
  });
}
