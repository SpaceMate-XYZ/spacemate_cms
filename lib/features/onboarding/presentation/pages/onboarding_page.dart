import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spacemate/features/onboarding/data/models/onboarding_slide.dart';
import 'package:spacemate/features/onboarding/presentation/bloc/feature_onboarding_cubit.dart';
import 'package:spacemate/features/onboarding/presentation/widgets/responsive_onboarding_carousel.dart';
import 'package:spacemate/core/di/injection_container.dart';
import 'dart:developer' as developer;

class OnboardingScreen extends StatefulWidget {
  final List<OnboardingSlide> slides;
  final int initialSlideIndex;
  final String? featureName;
  final String? category;

  const OnboardingScreen({
    super.key, 
    required this.slides,
    this.initialSlideIndex = 0,
    this.featureName,
    this.category,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final GlobalKey<ResponsiveOnboardingCarouselState> _carouselKey = GlobalKey<ResponsiveOnboardingCarouselState>();

  @override
  void initState() {
    super.initState();
    developer.log('OnboardingScreen: Initialized with ${widget.slides.length} slides, starting at slide ${widget.initialSlideIndex}');
    developer.log('OnboardingScreen: Feature name: ${widget.featureName}, Category: ${widget.category}');
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
      child: ResponsiveOnboardingCarousel(
        key: _carouselKey,
        slides: widget.slides,
        initialSlideIndex: widget.initialSlideIndex,
        featureName: widget.featureName,
        category: widget.category,
        onComplete: () => _completeOnboarding(context),
        onSkip: () => _completeOnboarding(context),
        showSkipButton: true,
        showProgressIndicator: true,
        showDontShowAgain: true,
      ),
    );
  }

  void _completeOnboarding(BuildContext context) {
    developer.log('OnboardingScreen: Completing onboarding');
    try {
      // Get the carousel state to check if "Don't show again" was selected
      final carouselState = _carouselKey.currentState;
      if (carouselState != null && carouselState.dontShowAgain) {
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
}
