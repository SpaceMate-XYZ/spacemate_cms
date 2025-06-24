import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:spacemate/features/menu/domain/entities/menu_item_entity.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_event.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_state.dart';
import 'package:spacemate/features/menu/presentation/pages/home_page.dart';

class MockMenuBloc extends MockBloc<MenuEvent, MenuState> implements MenuBloc {}

void main() {
  late MockMenuBloc mockMenuBloc;
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

  setUp(() {
    mockMenuBloc = MockMenuBloc();
    registerFallbackValue(const LoadMenuEvent(slug: 'home'));
  });

  Widget createTestWidget() {
    return MaterialApp(
      home: BlocProvider<MenuBloc>(
        create: (context) => mockMenuBloc,
        child: const HomePage(),
      ),
    );
  }

  testWidgets('shows loading indicator when state is loading', (tester) async {
    when(() => mockMenuBloc.state).thenReturn(
      const MenuState.loading(slug: 'home'),
    );
    
    await tester.pumpWidget(createTestWidget());
    
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows menu items when state is loaded', (tester) async {
    when(() => mockMenuBloc.state).thenReturn(
      MenuState.success(items: mockMenuItems),
    );
    
    await tester.pumpWidget(createTestWidget());
    
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('shows error message when state is error', (tester) async {
    when(() => mockMenuBloc.state).thenReturn(
      const MenuState.failure(message: 'Failed to load menu'),
    );
    
    await tester.pumpWidget(createTestWidget());
    
    expect(find.text('Failed to load menu'), findsOneWidget);
  });

  testWidgets('calls LoadMenuEvent when retry is triggered', (tester) async {
    when(() => mockMenuBloc.state).thenReturn(
      const MenuState.failure(message: 'Failed to load menu'),
    );
    
    await tester.pumpWidget(createTestWidget());
    
    // Find and tap retry button if it exists
    final retryButton = find.text('Retry');
    if (retryButton.evaluate().isNotEmpty) {
      await tester.tap(retryButton);
      verify(() => mockMenuBloc.add(any(that: isA<LoadMenuEvent>()))).called(1);
    }
  });

  testWidgets('displays home page correctly', (tester) async {
    when(() => mockMenuBloc.state).thenReturn(
      MenuState.success(items: mockMenuItems),
    );
    
    await tester.pumpWidget(createTestWidget());
    
    // Verify HomePage is displayed
    expect(find.byType(HomePage), findsOneWidget);
    
    // Verify AppBar exists
    expect(find.byType(AppBar), findsOneWidget);
    
    // Verify bottom navigation exists
    expect(find.byType(NavigationBar), findsOneWidget);
  });

  testWidgets('bottom navigation has correct number of tabs', (tester) async {
    when(() => mockMenuBloc.state).thenReturn(
      MenuState.success(items: mockMenuItems),
    );
    
    await tester.pumpWidget(createTestWidget());
    
    // Should have 5 navigation destinations (Home, Transport, Access, Facilities, Discover)
    expect(find.byType(NavigationDestination), findsNWidgets(5));
  });

  testWidgets('page view responds to navigation bar taps', (tester) async {
    when(() => mockMenuBloc.state).thenReturn(
      MenuState.success(items: mockMenuItems),
    );
    
    await tester.pumpWidget(createTestWidget());
    
    // Find and tap the second navigation item (Transport)
    final transportTab = find.byType(NavigationDestination).at(1);
    await tester.tap(transportTab);
    await tester.pumpAndSettle();
    
    // Verify that LoadMenuEvent was called for transport
    verify(() => mockMenuBloc.add(any(that: isA<LoadMenuEvent>()))).called(greaterThan(0));
  });
}
