import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:spacemate/features/onboarding/data/models/onboarding_slide.dart';
import 'package:spacemate/features/onboarding/presentation/bloc/feature_onboarding_cubit.dart';

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
  Widget build(BuildContext context) {
    if (widget.slides.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No onboarding content available.')),
      );
    }

    return Scaffold(
      body: OnBoardingSlider(
        totalPage: widget.slides.length,
        headerBackgroundColor: Colors.white,
        pageBackgroundColor: Colors.white,
        background: List.generate(
          widget.slides.length,
          (index) => CachedNetworkImage(
            imageUrl: widget.slides[index].imageUrl,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: BoxFit.cover,
          ),
        ),
        speed: 1.8,
        pageBodies: List.generate(
          widget.slides.length,
          (index) => Container(
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
                const SizedBox(
                  height: 20,
                ),
                Text(
                  widget.slides[index].body,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        // ignore: body_might_complete_normally_nullable
        onFinish: () {
          _completeOnboarding(context);
        },
        finishButtonText: widget.slides.last.buttonLabel ?? 'Get Started',
        trailing: Checkbox(
          value: _dontShowAgain,
          onChanged: (bool? value) {
            setState(() {
              _dontShowAgain = value ?? false;
            });
          },
        ),
        trailingFunction: () {
          _completeOnboarding(context);
        },
      ),
    );
  }

  void _completeOnboarding(BuildContext context) {
    if (_dontShowAgain) {
      context
          .read<FeatureOnboardingCubit>()
          .setOnboardingCompleted(widget.slides[0].feature);
    }
    context.go('/'); // Navigate to home or relevant screen
  }
}
