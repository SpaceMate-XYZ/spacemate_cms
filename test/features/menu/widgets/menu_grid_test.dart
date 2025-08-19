import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacemate/features/menu/presentation/widgets/menu_grid.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_state.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_event.dart';
import 'package:spacemate/features/menu/domain/entities/menu_item_entity.dart';
import 'package:spacemate/features/menu/presentation/widgets/menu_grid_item.dart';
import 'package:spacemate/core/di/injection_container.dart' show sl;
import 'package:spacemate/features/onboarding/presentation/bloc/feature_onboarding_cubit.dart';
import 'package:spacemate/features/onboarding/presentation/bloc/feature_onboarding_cubit.dart' as foc;

import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
class MockMenuBloc extends Mock implements MenuBloc {}
class MockFeatureOnboardingCubit extends Mock implements FeatureOnboardingCubit {}

class FakeMenuEvent extends Fake implements MenuEvent {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeMenuEvent());
  });
  testWidgets('MenuGrid shows loading state when isLoading true', (tester) async {
    const state = MenuState.loading(slug: 'home');
    final bloc = MockMenuBloc();
    when(() => bloc.state).thenReturn(state);
    whenListen(bloc, Stream<MenuState>.fromIterable([state]), initialState: state);

    // Ensure FeatureOnboardingCubit is available from GetIt for FeatureCardWithOnboarding
  final mockOnboarding = MockFeatureOnboardingCubit();
  when(() => mockOnboarding.state).thenReturn(const foc.FeatureOnboardingState.initial());
  whenListen<FeatureOnboardingState>(mockOnboarding, Stream<FeatureOnboardingState>.fromIterable([const foc.FeatureOnboardingState.initial()]), initialState: const foc.FeatureOnboardingState.initial());
  when(() => mockOnboarding.close()).thenAnswer((_) async {});
    if (!sl.isRegistered<FeatureOnboardingCubit>()) {
      sl.registerFactory<FeatureOnboardingCubit>(() => mockOnboarding);
    }

    await tester.pumpWidget(MaterialApp(
      home: BlocProvider<MenuBloc>.value(
        value: bloc,
        child: const MenuGrid(items: [], isLoading: true),
      ),
    ));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('MenuGrid shows empty state when items empty', (tester) async {
    const state = MenuState.success(items: []);
    final bloc = MockMenuBloc();
    when(() => bloc.state).thenReturn(state);
    whenListen(bloc, Stream<MenuState>.fromIterable([state]), initialState: state);

  final mockOnboarding = MockFeatureOnboardingCubit();
  when(() => mockOnboarding.state).thenReturn(const foc.FeatureOnboardingState.initial());
  whenListen<FeatureOnboardingState>(mockOnboarding, Stream<FeatureOnboardingState>.fromIterable([const foc.FeatureOnboardingState.initial()]), initialState: const foc.FeatureOnboardingState.initial());
  when(() => mockOnboarding.close()).thenAnswer((_) async {});
    if (!sl.isRegistered<FeatureOnboardingCubit>()) {
      sl.registerFactory<FeatureOnboardingCubit>(() => mockOnboarding);
    }

    await tester.pumpWidget(MaterialApp(
      home: BlocProvider<MenuBloc>.value(
        value: bloc,
        child: const MenuGrid(items: [], isLoading: false),
      ),
    ));

    expect(find.text('No items found'), findsOneWidget);
  });

  testWidgets('MenuGrid renders items when provided', (tester) async {
    const item = MenuItemEntity(
      id: 1,
      label: 'Test',
      icon: 'test',
      order: 0,
      isVisible: true,
      isAvailable: true,
    );
    final state = MenuState.success(items: [item]);
    final bloc = MockMenuBloc();
    when(() => bloc.state).thenReturn(state);
    whenListen(bloc, Stream<MenuState>.fromIterable([state]), initialState: state);

  final mockOnboarding = MockFeatureOnboardingCubit();
  when(() => mockOnboarding.state).thenReturn(const foc.FeatureOnboardingState.initial());
  whenListen<FeatureOnboardingState>(mockOnboarding, Stream<FeatureOnboardingState>.fromIterable([const foc.FeatureOnboardingState.initial()]), initialState: const foc.FeatureOnboardingState.initial());
  when(() => mockOnboarding.close()).thenAnswer((_) async {});
    if (!sl.isRegistered<FeatureOnboardingCubit>()) {
      sl.registerFactory<FeatureOnboardingCubit>(() => mockOnboarding);
    }

    await tester.pumpWidget(MaterialApp(
      home: BlocProvider<MenuBloc>.value(
        value: bloc,
        child: MenuGrid(items: [item], isLoading: false),
      ),
    ));

    // Expect the GridView to be present when items are provided
    expect(find.byType(GridView), findsOneWidget);
    // Clean up GetIt registrations
    addTearDown(() {
      if (sl.isRegistered<FeatureOnboardingCubit>()) {
        sl.reset();
      }
    });
  });

  testWidgets('tapping an item calls FeatureOnboardingCubit.checkOnboardingStatus', (tester) async {
    const item = MenuItemEntity(
      id: 2,
      label: 'TapTest',
      icon: 'test',
      order: 0,
      isVisible: true,
      isAvailable: true,
    );

    final state = MenuState.success(items: [item]);
    final bloc = MockMenuBloc();
    when(() => bloc.state).thenReturn(state);
    whenListen(bloc, Stream<MenuState>.fromIterable([state]), initialState: state);

    final mockOnboarding = MockFeatureOnboardingCubit();
    when(() => mockOnboarding.state).thenReturn(const foc.FeatureOnboardingState.initial());
    whenListen<FeatureOnboardingState>(mockOnboarding, Stream<FeatureOnboardingState>.fromIterable([const foc.FeatureOnboardingState.initial()]), initialState: const foc.FeatureOnboardingState.initial());
    when(() => mockOnboarding.checkOnboardingStatus(any(), any())).thenAnswer((_) async {});
    when(() => mockOnboarding.close()).thenAnswer((_) async {});
    if (!sl.isRegistered<FeatureOnboardingCubit>()) {
      sl.registerFactory<FeatureOnboardingCubit>(() => mockOnboarding);
    }

    await tester.pumpWidget(MaterialApp(
      home: BlocProvider<MenuBloc>.value(
        value: bloc,
        child: MenuGrid(items: [item], isLoading: false),
      ),
    ));

    await tester.pumpAndSettle();

    expect(find.byType(MenuGridItem), findsOneWidget);

    await tester.tap(find.byType(MenuGridItem).first);
    await tester.pumpAndSettle();

    verify(() => mockOnboarding.checkOnboardingStatus(item.label, item.navigationTarget)).called(1);

    addTearDown(() {
      if (sl.isRegistered<FeatureOnboardingCubit>()) {
        sl.reset();
      }
    });
  });

  testWidgets('error retry button dispatches RefreshMenuEvent on MenuBloc', (tester) async {
    const state = MenuState.failure(message: 'oops');
    final bloc = MockMenuBloc();
    when(() => bloc.state).thenReturn(state);
    whenListen(bloc, Stream<MenuState>.fromIterable([state]), initialState: state);

    final mockOnboarding = MockFeatureOnboardingCubit();
    when(() => mockOnboarding.state).thenReturn(const foc.FeatureOnboardingState.initial());
    whenListen<FeatureOnboardingState>(mockOnboarding, Stream<FeatureOnboardingState>.fromIterable([const foc.FeatureOnboardingState.initial()]), initialState: const foc.FeatureOnboardingState.initial());
    when(() => mockOnboarding.close()).thenAnswer((_) async {});
    if (!sl.isRegistered<FeatureOnboardingCubit>()) {
      sl.registerFactory<FeatureOnboardingCubit>(() => mockOnboarding);
    }

    await tester.pumpWidget(MaterialApp(
      home: BlocProvider<MenuBloc>.value(
        value: bloc,
        child: const MenuGrid(items: [], isLoading: false, errorMessage: 'oops'),
      ),
    ));

    await tester.pumpAndSettle();

  final retryButton = find.text('Try Again');
  expect(retryButton, findsOneWidget);

  await tester.tap(retryButton);
    await tester.pumpAndSettle();

    verify(() => bloc.add(any())).called(1);

    addTearDown(() {
      if (sl.isRegistered<FeatureOnboardingCubit>()) {
        sl.reset();
      }
    });
  });
}
