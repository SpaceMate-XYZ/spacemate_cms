import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spacemate/features/menu/presentation/pages/home_page.dart';
import 'package:spacemate/features/menu/presentation/pages/access_page.dart';
import 'package:spacemate/features/menu/presentation/pages/discover_page.dart';
import 'package:spacemate/features/menu/presentation/pages/facilities_page.dart';
import 'package:spacemate/features/menu/presentation/pages/transport_page.dart';
import 'package:spacemate/features/onboarding/data/models/onboarding_slide.dart';
import 'package:spacemate/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:spacemate/core/utils/feature_name_mapper.dart';
import 'package:spacemate/features/onboarding/domain/usecases/get_feature_by_name.dart';
import 'package:spacemate/core/di/injection_container.dart';
import 'dart:developer' as developer;

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      // Main navigation routes
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/access',
        name: 'access',
        builder: (context, state) => const AccessPage(),
      ),
      GoRoute(
        path: '/facilities',
        name: 'facilities',
        builder: (context, state) => const FacilitiesPage(),
      ),
      GoRoute(
        path: '/transport',
        name: 'transport',
        builder: (context, state) => const TransportPage(),
      ),
      GoRoute(
        path: '/discover',
        name: 'discover',
        builder: (context, state) => const DiscoverPage(),
      ),
      
      // Feature-specific routes with deep linking support
      GoRoute(
        path: '/feature/:featureName',
        name: 'feature',
        builder: (context, state) {
          final featureName = state.pathParameters['featureName']!;
          developer.log('AppRouter: Building feature page for: $featureName');
          return FeatureLandingPage(featureName: featureName);
        },
      ),
      
      // Onboarding routes with deep linking support
      GoRoute(
        path: '/onboarding/:featureName',
        name: 'onboarding',
        builder: (context, state) {
          final featureName = state.pathParameters['featureName']!;
          developer.log('AppRouter: Building onboarding page for: $featureName');
          return OnboardingLoaderPage(featureName: featureName);
        },
      ),
      
      // Direct onboarding slide routes
      GoRoute(
        path: '/onboarding/:featureName/slide/:slideIndex',
        name: 'onboarding-slide',
        builder: (context, state) {
          final featureName = state.pathParameters['featureName']!;
          final slideIndex = int.tryParse(state.pathParameters['slideIndex'] ?? '0') ?? 0;
          developer.log('AppRouter: Building onboarding slide page for: $featureName, slide: $slideIndex');
          return OnboardingLoaderPage(
            featureName: featureName,
            initialSlideIndex: slideIndex,
          );
        },
      ),
      
      // Legacy onboarding route for backward compatibility
      GoRoute(
        path: '/onboarding',
        name: 'onboarding-legacy',
        builder: (context, state) {
          final slides = state.extra as List<OnboardingSlide>?;
          developer.log('AppRouter: Building legacy onboarding page with ${slides?.length ?? 0} slides');
          if (slides != null) {
            return OnboardingScreen(slides: slides);
          }
          return const OnboardingErrorPage();
        },
      ),
    ],
    errorBuilder: (context, state) {
      developer.log('AppRouter: Error building route for path: ${state.uri.path}');
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Page not found',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Path: ${state.uri.path}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      );
    },
  );

  // Helper methods for navigation
  static void navigateToFeature(BuildContext context, String featureName) {
    developer.log('AppRouter: Navigating to feature: $featureName');
    context.go('/feature/$featureName');
  }

  static void navigateToOnboarding(BuildContext context, String featureName, {int? initialSlideIndex}) {
    developer.log('AppRouter: Navigating to onboarding for feature: $featureName, slide: $initialSlideIndex');
    if (initialSlideIndex != null) {
      context.go('/onboarding/$featureName/slide/$initialSlideIndex');
    } else {
      context.go('/onboarding/$featureName');
    }
  }

  static void navigateToOnboardingWithSlides(BuildContext context, List<OnboardingSlide> slides) {
    developer.log('AppRouter: Navigating to onboarding with ${slides.length} slides');
    context.go('/onboarding', extra: slides);
  }
}

// Feature Landing Page - shows feature details and allows navigation to onboarding
class FeatureLandingPage extends StatelessWidget {
  final String featureName;

  const FeatureLandingPage({super.key, required this.featureName});

  @override
  Widget build(BuildContext context) {
    final menuLabel = FeatureNameMapper.getLabelFromFeatureName(featureName) ?? featureName;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(menuLabel),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getFeatureIcon(featureName),
              size: 64,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              menuLabel,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => AppRouter.navigateToOnboarding(context, featureName),
              child: const Text('Start Onboarding'),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getFeatureIcon(String featureName) {
    // Map feature names to icons - you can expand this
    switch (featureName) {
      case 'parking':
        return Icons.directions_car;
      case 'valetparking':
        return Icons.local_parking;
      case 'evcharging':
        return Icons.ev_station;
      case 'building':
        return Icons.location_city;
      case 'office':
        return Icons.apartment;
      case 'lockers':
        return Icons.grid_on;
      case 'meetings':
        return Icons.meeting_room;
      case 'visitors':
        return Icons.person_add;
      case 'requests':
        return Icons.psychology_alt;
      case 'desks':
        return Icons.desk;
      case 'shuttles':
        return Icons.airport_shuttle;
      case 'fooddelivery':
        return Icons.moped;
      case 'cafeteria':
        return Icons.fastfood;
      case 'vending':
        return Icons.coffee_maker;
      case 'fitness':
        return Icons.fitness_center;
      case 'sports':
        return Icons.directions_run;
      case 'games':
        return Icons.sports_esports;
      case 'doctor':
        return Icons.medical_services;
      case 'counselor':
        return Icons.psychology;
      case 'spa':
        return Icons.spa;
      case 'lobby':
        return Icons.door_front_door;
      case 'lift':
        return Icons.elevator;
      case 'printer':
        return Icons.print;
      case 'carpools':
        return Icons.diversity_1;
      case 'companycabs':
        return Icons.local_taxi;
      default:
        return Icons.featured_play_list;
    }
  }
}

// Onboarding Loader Page - loads onboarding data and displays the carousel
class OnboardingLoaderPage extends StatefulWidget {
  final String featureName;
  final int initialSlideIndex;

  const OnboardingLoaderPage({
    super.key,
    required this.featureName,
    this.initialSlideIndex = 0,
  });

  @override
  State<OnboardingLoaderPage> createState() => _OnboardingLoaderPageState();
}

class _OnboardingLoaderPageState extends State<OnboardingLoaderPage> {
  late Future<List<OnboardingSlide>> _slidesFuture;

  @override
  void initState() {
    super.initState();
    _slidesFuture = _loadOnboardingSlides();
  }

  Future<List<OnboardingSlide>> _loadOnboardingSlides() async {
    try {
      final getFeatureByName = sl<GetFeatureByName>();
      final result = await getFeatureByName(widget.featureName).run();
      
      return result.fold(
        (failure) => throw Exception(failure.message),
        (response) {
          final slides = response.data
              .where((feature) => feature.attributes.onboardingCarousel != null)
              .expand((feature) => feature.attributes.onboardingCarousel!)
              .toList();
          
          if (slides.isEmpty) {
            throw Exception('No onboarding slides found for ${widget.featureName}');
          }
          
          return slides;
        },
      );
    } catch (e) {
      throw Exception('Failed to load onboarding slides: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${FeatureNameMapper.getLabelFromFeatureName(widget.featureName) ?? widget.featureName} Onboarding'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: FutureBuilder<List<OnboardingSlide>>(
        future: _slidesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading onboarding...'),
                ],
              ),
            );
          }
          
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading onboarding',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.pop(),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            );
          }
          
          final slides = snapshot.data!;
          return OnboardingScreen(
            slides: slides,
            initialSlideIndex: widget.initialSlideIndex,
          );
        },
      ),
    );
  }
}

// Error page for onboarding
class OnboardingErrorPage extends StatelessWidget {
  const OnboardingErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Onboarding Error'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text(
              'No onboarding data provided',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Please navigate to a specific feature onboarding',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
