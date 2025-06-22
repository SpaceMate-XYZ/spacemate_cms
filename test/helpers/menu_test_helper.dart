import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class MenuTestHelper {
  /// Finds all menu items in the menu
  static Finder findMenuItems() {
    return find.byType(ListTile);
  }

  /// Finds a menu item by its title
  static Finder findMenuItemByTitle(String title) {
    return find.widgetWithText(ListTile, title);
  }

  /// Taps on a menu item by its title
  static Future<void> tapMenuItem(WidgetTester tester, String title) async {
    await tester.tap(findMenuItemByTitle(title));
    await tester.pumpAndSettle();
  }

  /// Verifies that the current route matches the expected route name
  static void verifyCurrentRoute(String expectedRouteName) {
    // This assumes you're using named routes and have a way to access the current route
    // You might need to adjust this based on your routing solution
    final currentRoute = WidgetsBinding.instance.window.defaultRouteName;
    expect(currentRoute, equals(expectedRouteName));
  }

  /// Verifies that a menu item is visible and enabled
  static void verifyMenuItemIsEnabled(String title) {
    final finder = findMenuItemByTitle(title);
    expect(finder, findsOneWidget);
    final widget = finder.evaluate().first.widget as ListTile;
    expect(widget.enabled, isTrue);
  }

  /// Verifies that a menu item is not visible or is disabled
  static void verifyMenuItemIsNotAvailable(String title) {
    final finder = findMenuItemByTitle(title);
    if (finder.evaluate().isNotEmpty) {
      final widget = finder.evaluate().first.widget as ListTile;
      expect(widget.enabled, isFalse);
    }
  }
}
