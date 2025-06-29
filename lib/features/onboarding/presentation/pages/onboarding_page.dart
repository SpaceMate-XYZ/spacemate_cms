import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:spacemate/features/onboarding/data/models/onboarding_slide.dart';
import 'package:spacemate/features/onboarding/presentation/bloc/feature_onboarding_cubit.dart';
import 'package:spacemate/core/di/injection_container.dart';
import 'package:spacemate/core/utils/image_utils.dart';
import 'package:spacemate/core/config/cors_config.dart';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class OnboardingScreen extends StatefulWidget {
  final List<OnboardingSlide> slides;
  final int initialSlideIndex;

  const OnboardingScreen({
    super.key, 
    required this.slides,
    this.initialSlideIndex = 0,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool _dontShowAgain = false;

  @override
  void initState() {
    super.initState();
    developer.log('OnboardingScreen: Initialized with ${widget.slides.length} slides, starting at slide ${widget.initialSlideIndex}');
    for (int i = 0; i < widget.slides.length; i++) {
      developer.log('OnboardingScreen: Slide $i - Title: ${widget.slides[i].title}, Header: ${widget.slides[i].header}, Image: ${widget.slides[i].imageUrl}');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.slides.isEmpty) {
      developer.log('OnboardingScreen: No slides available');
      return const Scaffold(
        body: Center(child: Text('No onboarding content available.')),
      );
    }

    return BlocProvider<FeatureOnboardingCubit>(
      create: (context) => sl<FeatureOnboardingCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.slides[0].title),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => _completeOnboarding(context),
          ),
        ),
        body: OnBoardingSlider(
          totalPage: widget.slides.length,
          headerBackgroundColor: Colors.white,
          pageBackgroundColor: Colors.white,
          background: List.generate(
            widget.slides.length,
            (index) {
              final slide = widget.slides[index];
              
              developer.log('OnboardingScreen: Creating background for slide $index');
              developer.log('OnboardingScreen: Image URL: ${slide.imageUrl}');
              developer.log('OnboardingScreen: Slide title: ${slide.title}');
              developer.log('OnboardingScreen: Slide header: ${slide.header}');
              
              // Test CDN accessibility first
              return FutureBuilder<Map<String, dynamic>>(
                future: ImageUtils.testCdnImageAccessibility(slide.imageUrl),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  }
                  
                  final accessibilityResults = snapshot.data ?? {};
                  developer.log('OnboardingScreen: CDN accessibility results for ${slide.imageUrl}: $accessibilityResults');
                  
                  // Try to load the image with the best available headers
                  return ImageUtils.loadImage(
                    imageUrl: slide.imageUrl,
                    errorWidget: (context, url, error) {
                      developer.log('OnboardingScreen: Image failed to load: $url, error: $error');
                      developer.log('OnboardingScreen: Accessibility results: $accessibilityResults');
                      
                      // Show detailed error information in development
                      if (CorsConfig.isDevelopment) {
                        return Container(
                          color: Colors.red[50],
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _getFeatureIcon(slide.feature),
                                  size: 80,
                                  color: Colors.red[600],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Image Loading Failed',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red[800],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'URL: $url',
                                  style: TextStyle(fontSize: 12, color: Colors.red[600]),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Error: $error',
                                  style: TextStyle(fontSize: 10, color: Colors.red[500]),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      
                      return _buildFallback(slide);
                    },
                  );
                },
              );
            },
          ),
          speed: 1.8,
          pageBodies: List.generate(
            widget.slides.length,
            (index) {
              developer.log('OnboardingScreen: Creating page body for slide $index');
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                    ),
                    Text(
                      widget.slides[index].header,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 24.0,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    if (widget.slides[index].body != null && widget.slides[index].body!.isNotEmpty)
                      Text(
                        widget.slides[index].body!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    const SizedBox(height: 20),
                    // Add slide indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        widget.slides.length,
                        (dotIndex) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: dotIndex == index ? Colors.blue : Colors.grey[300],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          onFinish: () {
            developer.log('OnboardingScreen: onFinish called');
            _completeOnboarding(context);
          },
          finishButtonText: widget.slides.last.buttonLabel ?? 'Get Started',
          trailing: Checkbox(
            value: _dontShowAgain,
            onChanged: (bool? value) {
              setState(() {
                _dontShowAgain = value ?? false;
              });
              developer.log('OnboardingScreen: Dont show again changed to: $_dontShowAgain');
            },
          ),
          trailingFunction: () {
            developer.log('OnboardingScreen: trailingFunction called');
            _completeOnboarding(context);
          },
        ),
      ),
    );
  }

  void _completeOnboarding(BuildContext context) {
    developer.log('OnboardingScreen: Completing onboarding');
    try {
      if (_dontShowAgain) {
        developer.log('OnboardingScreen: Setting onboarding completed for feature: ${widget.slides[0].feature}');
        context
            .read<FeatureOnboardingCubit>()
            .setOnboardingCompleted(widget.slides[0].feature);
      }
      
      developer.log('OnboardingScreen: Navigating to home');
      context.go('/');
    } catch (e) {
      developer.log('OnboardingScreen: Error completing onboarding: $e');
      // Fallback navigation
      try {
        Navigator.of(context).pop();
      } catch (e2) {
        developer.log('OnboardingScreen: Fallback navigation also failed: $e2');
      }
    }
  }

  /// Get icon for a specific feature
  IconData _getFeatureIcon(String featureName) {
    switch (featureName.toLowerCase()) {
      case 'parking':
        return Icons.directions_car;
      case 'valetparking':
      case 'valet_parking':
        return Icons.local_parking;
      case 'evcharging':
      case 'ev_charging':
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

  Widget _buildFallback(OnboardingSlide slide) {
    return ImageUtils.createFeaturePlaceholder(
      icon: _getFeatureIcon(slide.feature),
      title: slide.header,
      subtitle: slide.body,
    );
  }
}
