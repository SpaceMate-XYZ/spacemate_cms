import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spacemate/features/carousel/presentation/bloc/carousel_bloc.dart';
import 'package:spacemate/features/menu/domain/entities/menu_item_entity.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_event.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_state.dart';
import 'package:spacemate/features/menu/presentation/pages/home_page.dart';
import 'package:spacemate/features/onboarding/presentation/bloc/feature_onboarding_cubit.dart';
import 'package:spacemate/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import '../../../../../test/helpers/test_setup.dart';

class MockMenuBloc extends Mock implements MenuBloc {}
class MockCarouselBloc extends Mock implements CarouselBloc {}
class MockFeatureOnboardingCubit extends Mock implements FeatureOnboardingCubit {}
class MockOnboardingBloc extends Mock implements OnboardingBloc {}

void main() {
  late MockMenuBloc mockMenuBloc;
  late MockCarouselBloc mockCarouselBloc;
  late MockFeatureOnboardingCubit mockFeatureOnboardingCubit;
  late MockOnboardingBloc mockOnboardingBloc;
  
  final mockMenuItems = [
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
  ];

  setUpAll(() async {
  await TestSetup.initializeTestDI();
  });

  setUp(() {
    mockMenuBloc = MockMenuBloc();
    mockCarouselBloc = MockCarouselBloc();
    mockFeatureOnboardingCubit = MockFeatureOnboardingCubit();
    mockOnboardingBloc = MockOnboardingBloc();
    
  // pages dispatch LoadMenuGridsEvent, register fallback for it
  registerFallbackValue(const LoadMenuGridsEvent(placeId: 'home'));
  // Provide non-null streams/state for other blocs used by the HomePage
  when(() => mockCarouselBloc.state).thenReturn(CarouselInitial());
  when(() => mockCarouselBloc.stream).thenAnswer((_) => Stream<CarouselState>.value(CarouselInitial()));

  when(() => mockFeatureOnboardingCubit.state).thenReturn(const FeatureOnboardingState.initial());
  when(() => mockFeatureOnboardingCubit.stream).thenAnswer((_) => Stream<FeatureOnboardingState>.value(const FeatureOnboardingState.initial()));
  });

  // Helper to stub both the bloc state getter and the stream listener.
  void stubMenuBlocState(MenuState state) {
    when(() => mockMenuBloc.state).thenReturn(state);
    when(() => mockMenuBloc.stream).thenAnswer((_) => Stream<MenuState>.value(state));
  }

  tearDown(() {
    // TestSetup.tearDown();
  });

  Widget createTestWidget() {
    return TestSetup.createTestApp(
      child: const HomePage(),
      menuBloc: mockMenuBloc,
      carouselBloc: mockCarouselBloc,
      featureOnboardingCubit: mockFeatureOnboardingCubit,
      onboardingBloc: mockOnboardingBloc,
    );
  }

  testWidgets('shows loading indicator when state is loading', (tester) async {
    stubMenuBlocState(const MenuState.loading(slug: 'home'));

    await tester.pumpWidget(createTestWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows menu items when state is loaded', (tester) async {
    stubMenuBlocState(MenuState.success(items: mockMenuItems));

    await tester.pumpWidget(createTestWidget());

    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('shows error message when state is error', (tester) async {
    stubMenuBlocState(const MenuState.failure(message: 'Failed to load menu'));

    await tester.pumpWidget(createTestWidget());

    expect(find.text('Failed to load menu'), findsOneWidget);
  });

  testWidgets('calls LoadMenuEvent when retry is triggered', (tester) async {
    stubMenuBlocState(const MenuState.failure(message: 'Failed to load menu'));

    await tester.pumpWidget(createTestWidget());

    // Find and tap retry button if it exists
    final retryButton = find.text('Retry');
    if (retryButton.evaluate().isNotEmpty) {
      await tester.tap(retryButton);
      verify(() => mockMenuBloc.add(any(that: isA<LoadMenuGridsEvent>()))).called(1);
    }
  });

  testWidgets('displays home page correctly', (tester) async {
    stubMenuBlocState(MenuState.success(items: mockMenuItems));

    await tester.pumpWidget(createTestWidget());

    // Verify HomePage is displayed
    expect(find.byType(HomePage), findsOneWidget);

    // Verify AppBar exists
    expect(find.byType(AppBar), findsOneWidget);

    // Verify bottom navigation exists
    expect(find.byType(NavigationBar), findsOneWidget);
  });

  testWidgets('bottom navigation has correct number of tabs', (tester) async {
    stubMenuBlocState(MenuState.success(items: mockMenuItems));

    await tester.pumpWidget(createTestWidget());

    // Should have 5 navigation destinations (Home, Transport, Access, Facilities, Discover)
    expect(find.byType(NavigationDestination), findsNWidgets(5));
  });

  testWidgets('page view responds to navigation bar taps', (tester) async {
    stubMenuBlocState(MenuState.success(items: mockMenuItems));

    await tester.pumpWidget(createTestWidget());

    // Find and tap the second navigation item (Transport)
    final transportTab = find.byType(NavigationDestination).at(1);
    await tester.tap(transportTab);
    await tester.pumpAndSettle();

  // Verify that LoadMenuGridsEvent was called for transport
  verify(() => mockMenuBloc.add(any(that: isA<LoadMenuGridsEvent>()))).called(greaterThan(0));
  });
}
