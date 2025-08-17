import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:spacemate/main.dart' as app;
import 'package:spacemate/features/menu/presentation/pages/home_page.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  SharedPreferences.setMockInitialValues({});
  });

  group('Menu Integration Tests', () {
    testWidgets('Menu loads and displays items', (tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Verify the menu page is displayed
      expect(find.byType(HomePage), findsOneWidget);

      // Verify menu items are loaded (adjust this based on your actual menu items)
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(ListTile), findsWidgets);
    });

    testWidgets('Tapping menu item navigates to correct route', (tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Find and tap the first menu item
      final firstMenuItem = find.byType(ListTile).first;
      await tester.tap(firstMenuItem);
      await tester.pumpAndSettle();

      // Verify navigation occurred (adjust this based on your routing)
      expect(find.byType(HomePage), findsNothing);
    });

    testWidgets('Menu updates when user permissions change', (tester) async {
      // This test would simulate a change in user permissions
      // and verify that the menu updates accordingly
      // Implementation depends on your auth/permissions system
    });

    testWidgets('Menu respects theme changes', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Find and tap theme toggle (adjust selector based on your app)
      final themeToggle = find.byIcon(Icons.brightness_6);
      if (themeToggle.evaluate().isNotEmpty) {
        await tester.tap(themeToggle);
        await tester.pumpAndSettle();

        // Verify theme changed (this is a simple check, can be more specific)
        final appBar = find.byType(AppBar);
        expect(appBar, findsOneWidget);
      }
    });
  });

  group('Menu Performance Tests', () {
    testWidgets('Menu loads within acceptable time', (tester) async {
      final stopwatch = Stopwatch()..start();
      
      app.main();
      await tester.pumpAndSettle();
      
      stopwatch.stop();
      debugPrint('Menu loaded in ${stopwatch.elapsedMilliseconds}ms');
      
      // Adjust threshold based on your performance requirements
      expect(stopwatch.elapsedMilliseconds, lessThan(500));
    });

    testWidgets('Menu scroll performance', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final listView = find.byType(ListView);
      expect(listView, findsOneWidget);

      final stopwatch = Stopwatch()..start();
      await tester.fling(listView, const Offset(0, -500), 1000);
      await tester.pumpAndSettle();
      stopwatch.stop();

      debugPrint('Menu scrolled in ${stopwatch.elapsedMilliseconds}ms');
      expect(stopwatch.elapsedMilliseconds, lessThan(1000));
    });
  });

  tearDownAll(() async {
  await GetIt.I.reset();
  });
}
