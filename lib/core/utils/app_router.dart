import 'package:flutter/material.dart';
import 'package:spacemate/features/menu/presentation/pages/home_page.dart';
import 'package:spacemate/features/parking/presentation/pages/parking_onboarding_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/parking-onboarding',
        builder: (context, state) => const ParkingOnboardingPage(),
      ),
      // Add more routes here as needed
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri.path}'),
      ),
    ),
  );

  static Route<dynamic> generateRoute(RouteSettings settings) {
    // This is a fallback route generator for non-GoRouter navigation
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case '/parking-onboarding':
        return MaterialPageRoute(builder: (_) => const ParkingOnboardingPage());
      // Add more routes here as needed
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
