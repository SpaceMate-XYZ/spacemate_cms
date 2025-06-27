import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';

class ParkingOnboardingPage extends StatelessWidget {
  const ParkingOnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return OnBoardingSlider(
      headerBackgroundColor: Colors.white,
      finishButtonText: 'Get Started',
      onFinish: () {
        Navigator.pop(context); // Go back after finishing onboarding
      },
      skipTextButton: const Text('Skip'),
      trailingFunction: () {
        Navigator.pop(context); // Go back if trailing button is pressed
      },
      background: [
        Image.network('https://pub-a82fb85882784f3591b34db19d350dfc.r2.dev/parking_onboarding_1.jpg'),
        Image.network('https://pub-a82fb85882784f3591b34db19d350dfc.r2.dev/parking_onboarding_4.jpg'),
      ],
      totalPage: 2,
      speed: 1.8,
      pageBodies: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 480,
              ),
              Text(
                'ParkMate',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 20),
              Text(
                'Find, prebook, pay, park',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 20),
              Text(
                'Pre-book, pay or get a pass for your vehicles or those of your visitors or customers. Know parking availability in real-time and reserve your space with ease.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 480,
              ),
              Text(
                'ParkMate',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 20),
              Text(
                'Park here',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 20),
              Text(
                'Find parking now',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }
}