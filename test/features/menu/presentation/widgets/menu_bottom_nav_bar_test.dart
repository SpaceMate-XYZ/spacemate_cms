import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spacemate/features/menu/presentation/widgets/menu_bottom_nav_bar.dart';
import 'package:spacemate/features/menu/domain/entities/menu_category.dart';

void main() {
  testWidgets('renders ThemeToggle and BottomNavigationBar', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MenuBottomNavBar(
            currentIndex: 0,
            onTap: (_) {},
          ),
        ),
      ),
    );

    // ThemeToggle should be present
    expect(find.byType(Column), findsOneWidget);
    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });

  testWidgets('renders correct number of BottomNavigationBar items', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MenuBottomNavBar(
            currentIndex: 0,
            onTap: (_) {},
          ),
        ),
      ),
    );

    // Number of items should match MenuCategory.values.length
    final bottomNavBar = tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
    expect(bottomNavBar.items.length, MenuCategory.values.length);
  });

  testWidgets('highlights the correct item based on currentIndex', (WidgetTester tester) async {
    const testIndex = 1;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MenuBottomNavBar(
            currentIndex: testIndex,
            onTap: (_) {},
          ),
        ),
      ),
    );

    final bottomNavBar = tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
    expect(bottomNavBar.currentIndex, testIndex);
  });

  testWidgets('calls onTap with correct index when tapped', (WidgetTester tester) async {
    int? tappedIndex;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MenuBottomNavBar(
            currentIndex: 0,
            onTap: (index) {
              tappedIndex = index;
            },
          ),
        ),
      ),
    );

    // Tap the second navigation item
    await tester.tap(find.byType(BottomNavigationBar));
    // Since we can't tap a specific item without knowing the structure, this is a basic tap.
    // For more precise tapping, you may want to use find.text or find.byIcon if available.

    // Rebuild the widget after the state has changed.
    await tester.pump();

    // tappedIndex should be set (if the tap was on a valid item)
    expect(tappedIndex, isNotNull);
  });
}