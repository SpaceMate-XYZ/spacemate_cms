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
    redirect: (context, state) {
      developer.log('AppRouter: Redirect called for path: ${state.uri.path}');
      return null;
    },
    routes: [
      // Main navigation routes with category support
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) {
          developer.log('AppRouter: Building home page');
          return const HomePage();
        },
      ),
      GoRoute(
        path: '/category/:category',
        name: 'category',
        builder: (context, state) {
          final category = state.pathParameters['category']!;
          developer.log('AppRouter: Building category page for: $category');
          return _buildCategoryPage(category);
        },
      ),
      GoRoute(
        path: '/access',
        name: 'access',
        builder: (context, state) {
          developer.log('AppRouter: Building access page');
          return const AccessPage();
        },
      ),
      GoRoute(
        path: '/facilities',
        name: 'facilities',
        builder: (context, state) {
          developer.log('AppRouter: Building facilities page');
          return const FacilitiesPage();
        },
      ),
      GoRoute(
        path: '/transport',
        name: 'transport',
        builder: (context, state) {
          developer.log('AppRouter: Building transport page');
          return const TransportPage();
        },
      ),
      GoRoute(
        path: '/discover',
        name: 'discover',
        builder: (context, state) {
          developer.log('AppRouter: Building discover page');
          return const DiscoverPage();
        },
      ),
      
      // Feature-specific routes with category support
      GoRoute(
        path: '/category/:category/feature/:featureName',
        name: 'category-feature',
        builder: (context, state) {
          final category = state.pathParameters['category']!;
          final featureName = state.pathParameters['featureName']!;
          developer.log('AppRouter: Building category feature page for: $category/$featureName');
          return FeatureLandingPage(
            category: category,
            featureName: featureName,
          );
        },
      ),
      
      // Feature-specific routes with deep linking support (legacy)
      GoRoute(
        path: '/feature/:featureName',
        name: 'feature',
        builder: (context, state) {
          final featureName = state.pathParameters['featureName']!;
          developer.log('AppRouter: Building feature page for: $featureName');
          return FeatureLandingPage(featureName: featureName);
        },
      ),
      
      // Onboarding routes with category support
      GoRoute(
        path: '/category/:category/onboarding/:featureName',
        name: 'category-onboarding',
        builder: (context, state) {
          final category = state.pathParameters['category']!;
          final featureName = state.pathParameters['featureName']!;
          developer.log('AppRouter: Building category onboarding page for: $category/$featureName');
          return OnboardingLoaderPage(
            category: category,
            featureName: featureName,
          );
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
      
      // Individual onboarding slide routes with category support
      GoRoute(
        path: '/category/:category/onboarding/:featureName/:slideNumber',
        name: 'category-onboarding-slide',
        builder: (context, state) {
          final category = state.pathParameters['category']!;
          final featureName = state.pathParameters['featureName']!;
          final slideNumber = state.pathParameters['slideNumber']!;
          
          // Convert slide number to index (1-based to 0-based)
          final slideIndex = int.tryParse(slideNumber) ?? 1;
          final actualIndex = slideIndex - 1; // Convert to 0-based index
          
          developer.log('AppRouter: Building category onboarding slide page for: $category/$featureName, slide: $slideNumber (index: $actualIndex)');
          return OnboardingLoaderPage(
            category: category,
            featureName: featureName,
            initialSlideIndex: actualIndex,
          );
        },
      ),
      
      // Individual onboarding slide routes (1, 2, 3, 4)
      GoRoute(
        path: '/onboarding/:featureName/:slideNumber',
        name: 'onboarding-slide',
        builder: (context, state) {
          final featureName = state.pathParameters['featureName']!;
          final slideNumber = state.pathParameters['slideNumber']!;
          
          // Convert slide number to index (1-based to 0-based)
          final slideIndex = int.tryParse(slideNumber) ?? 1;
          final actualIndex = slideIndex - 1; // Convert to 0-based index
          
          developer.log('AppRouter: Building onboarding slide page for: $featureName, slide: $slideNumber (index: $actualIndex)');
          return OnboardingLoaderPage(
            featureName: featureName,
            initialSlideIndex: actualIndex,
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

  // Helper method to build category pages
  static Widget _buildCategoryPage(String category) {
    switch (category.toLowerCase()) {
      case 'home':
        return const HomePage();
      case 'access':
        return const AccessPage();
      case 'facilities':
        return const FacilitiesPage();
      case 'transport':
        return const TransportPage();
      case 'discover':
        return const DiscoverPage();
      default:
        return const HomePage();
    }
  }

  // Helper methods for navigation
  static void navigateToCategory(BuildContext context, String category) {
    developer.log('AppRouter: navigateToCategory called with category: $category');
    try {
      context.go('/category/$category');
      developer.log('AppRouter: Category navigation completed successfully');
    } catch (e) {
      developer.log('AppRouter: Category navigation failed: $e');
      rethrow;
    }
  }

  static void navigateToFeature(BuildContext context, String featureName, {String? category}) {
    developer.log('AppRouter: navigateToFeature called with featureName: $featureName, category: $category');
    try {
      if (category != null) {
        context.go('/category/$category/feature/$featureName');
      } else {
        context.go('/feature/$featureName');
      }
      developer.log('AppRouter: Feature navigation completed successfully');
    } catch (e) {
      developer.log('AppRouter: Feature navigation failed: $e');
      rethrow;
    }
  }

  static void navigateToOnboarding(BuildContext context, String featureName, {String? category, int? initialSlideIndex}) {
    developer.log('AppRouter: navigateToOnboarding called with featureName: $featureName, category: $category, slide: $initialSlideIndex');
    try {
      if (initialSlideIndex != null) {
        // Convert 0-based index to 1-based slide number
        final slideNumber = initialSlideIndex + 1;
        if (category != null) {
          context.go('/category/$category/onboarding/$featureName/$slideNumber');
        } else {
          context.go('/onboarding/$featureName/$slideNumber');
        }
      } else {
        if (category != null) {
          context.go('/category/$category/onboarding/$featureName');
        } else {
          context.go('/onboarding/$featureName');
        }
      }
      developer.log('AppRouter: Onboarding navigation completed successfully');
    } catch (e) {
      developer.log('AppRouter: Onboarding navigation failed: $e');
      rethrow;
    }
  }

  static void navigateToOnboardingWithSlides(BuildContext context, List<OnboardingSlide> slides) {
    developer.log('AppRouter: navigateToOnboardingWithSlides called with ${slides.length} slides');
    try {
      context.go('/onboarding', extra: slides);
      developer.log('AppRouter: Onboarding with slides navigation completed successfully');
    } catch (e) {
      developer.log('AppRouter: Onboarding with slides navigation failed: $e');
      rethrow;
    }
  }
}

// Feature Landing Page - shows feature details and allows navigation to onboarding
class FeatureLandingPage extends StatelessWidget {
  final String featureName;
  final String? category;

  const FeatureLandingPage({super.key, required this.featureName, this.category});

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
              onPressed: () => AppRouter.navigateToOnboarding(context, featureName, category: category),
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
  final String? category;
  final int initialSlideIndex;

  const OnboardingLoaderPage({
    super.key,
    required this.featureName,
    this.category,
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
      developer.log('OnboardingLoaderPage: Loading slides for feature: ${widget.featureName}');
      final getFeatureByName = sl<GetFeatureByName>();
      final result = await getFeatureByName(GetFeatureByNameParams(featureName: widget.featureName));
      
      return result.fold(
        (failure) {
          developer.log('OnboardingLoaderPage: API call failed: ${failure.message}');
          throw Exception(failure.message);
        },
        (feature) {
          developer.log('OnboardingLoaderPage: API call successful for feature: ${widget.featureName}');
          developer.log('OnboardingLoaderPage: Feature has ${feature.attributes.onboardingCarousel?.length ?? 0} slides');
          
          if (feature.attributes.onboardingCarousel == null || feature.attributes.onboardingCarousel!.isEmpty) {
            throw Exception('No onboarding slides found for ${widget.featureName}');
          }
          
          return feature.attributes.onboardingCarousel!;
        },
      );
    } catch (e) {
      developer.log('OnboardingLoaderPage: Failed to load onboarding slides: $e');
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
