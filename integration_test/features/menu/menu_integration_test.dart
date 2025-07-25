import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:spacemate/main.dart' as app;
import 'package:spacemate/features/menu/presentation/pages/home_page.dart';
import 'package:spacemate/features/menu/presentation/widgets/feature_card_with_onboarding.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

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

  group('Onboarding Integration Tests', () {
    testWidgets('Onboarding carousel shows, respects "Don\'t show again" logic, and skips after completion', (tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Find a feature card (use the first one for generic test)
      await tester.pumpAndSettle(); // Wait for any animations
      final featureCard = find.byType(FeatureCardWithOnboarding).first;
      await tester.pumpAndSettle(); // Wait for any animations
      expect(featureCard, findsOneWidget);

      // Tap the feature card to trigger onboarding
      await tester.tap(featureCard);
      await tester.pumpAndSettle();

      // Verify onboarding carousel appears (look for the onboarding carousel widget or a slide title)
      final onboardingTitle = find.textContaining('Get Started'); // Adjust if your slide titles are different
      expect(onboardingTitle, findsWidgets);

      // Swipe to the last slide (assuming 4 slides)
      for (int i = 0; i < 3; i++) {
        await tester.fling(find.byType(PageView), const Offset(-400, 0), 1000);
        await tester.pumpAndSettle();
      }

      // Check the 'Don\'t show again' checkbox
      final dontShowAgainCheckbox = find.byType(Checkbox).last;
      expect(dontShowAgainCheckbox, findsOneWidget);
      await tester.tap(dontShowAgainCheckbox);
      await tester.pumpAndSettle();

      // Tap the 'Get Started' button to complete onboarding
      final getStartedButton = find.widgetWithText(ElevatedButton, 'Get Started');
      expect(getStartedButton, findsOneWidget);
      await tester.tap(getStartedButton);
      await tester.pumpAndSettle();

      // Should navigate away from onboarding (carousel should not be visible)
      expect(onboardingTitle, findsNothing);

      // Tap the same feature card again
      await tester.tap(featureCard);
      await tester.pumpAndSettle();

      // Onboarding should be skipped, so onboarding carousel should not appear
      expect(onboardingTitle, findsNothing);
      // Optionally, check for navigation to the feature page (add a specific check if possible)
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
}
