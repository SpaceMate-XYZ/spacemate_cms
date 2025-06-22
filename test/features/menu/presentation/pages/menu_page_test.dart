import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spacemate/features/menu/domain/entities/menu_item_entity.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:spacemate/features/menu/presentation/pages/menu_page.dart';

class MockMenuBloc extends MockBloc<MenuEvent, MenuState> implements MenuBloc {}

void main() {
  late MockMenuBloc mockMenuBloc;
  final mockMenuItems = [
    MenuItemEntity(
      id: '1',
      title: 'Dashboard',
      icon: 'dashboard',
      category: MenuCategory.dashboard,
      route: '/dashboard',
      isActive: true,
      order: 1,
    ),
    MenuItemEntity(
      id: '2',
      title: 'Settings',
      icon: 'settings',
      category: MenuCategory.settings,
      route: '/settings',
      isActive: true,
      order: 2,
    ),
  ];

  setUp(() {
    mockMenuBloc = MockMenuBloc();
  });

  Widget createTestWidget() {
    return MaterialApp(
      home: BlocProvider<MenuBloc>(
        create: (context) => mockMenuBloc,
        child: const MenuPage(),
      ),
    );
  }

  testWidgets('shows loading indicator when state is loading', (tester) async {
    when(() => mockMenuBloc.state).thenReturn(const MenuState.loading());
    
    await tester.pumpWidget(createTestWidget());
    
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows menu items when state is loaded', (tester) async {
    when(() => mockMenuBloc.state)
        .thenReturn(MenuState.loaded(mockMenuItems));
    
    await tester.pumpWidget(createTestWidget());
    
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.byType(ListTile), findsNWidgets(mockMenuItems.length));
  });

  testWidgets('shows error message when state is error', (tester) async {
    when(() => mockMenuBloc.state)
        .thenReturn(const MenuState.error('Failed to load menu'));
    
    await tester.pumpWidget(createTestWidget());
    
    expect(find.text('Failed to load menu'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('calls LoadMenu when retry button is tapped', (tester) async {
    when(() => mockMenuBloc.state)
        .thenReturn(const MenuState.error('Failed to load menu'));
    
    await tester.pumpWidget(createTestWidget());
    
    await tester.tap(find.text('Retry'));
    
    verify(() => mockMenuBloc.add(any<LoadMenu>())).called(1);
  });

  testWidgets('navigates to correct route when menu item is tapped', 
    (tester) async {
      when(() => mockMenuBloc.state)
          .thenReturn(MenuState.loaded(mockMenuItems));
      
      final testRouteObserver = TestRouteObserver<ModalRoute>();
      
      await tester.pumpWidget(
        MaterialApp(
          navigatorObservers: [testRouteObserver],
          home: BlocProvider<MenuBloc>(
            create: (context) => mockMenuBloc,
            child: const MenuPage(),
          ),
        ),
      );
      
      await tester.tap(find.text('Dashboard'));
      await tester.pumpAndSettle();
      
      // Verify navigation occurred
      expect(find.byType(MenuPage), findsNothing);
    },
  );
}

// Helper class to test navigation
class TestRouteObserver<R extends Route<dynamic>> extends NavigatorObserver {
  final List<R> history = [];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    history.add(route as R);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute != null) {
      history.add(newRoute as R);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    history.removeLast();
  }
}
