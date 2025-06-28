import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:spacemate/features/onboarding/data/models/onboarding_carousel.dart';
import 'package:spacemate/features/onboarding/data/models/onboarding_slide.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tOnboardingSlideModel = OnboardingSlide(
    id: 1,
    feature: 'Parking',
    screen: 1,
    title: 'Welcome to Parking',
    imageUrl: 'https://example.com/image1.png',
    header: 'Find your perfect spot',
    body: 'Easily locate and reserve parking spaces.',
    buttonLabel: null,
  );

  const tOnboardingSlideModel2 = OnboardingSlide(
    id: 2,
    feature: 'Parking',
    screen: 2,
    title: 'Secure and Convenient',
    imageUrl: 'https://example.com/image2.png',
    header: 'Your vehicle is safe with us',
    body: 'Advanced security features for peace of mind.',
    buttonLabel: 'Get Started',
  );

  const tOnboardingCarouselModel = OnboardingCarousel(
    slides: [
      tOnboardingSlideModel,
      tOnboardingSlideModel2,
    ],
  );

  group('OnboardingCarousel', () {
    test(
      'should return a valid model when the JSON is parsed',
      () async {
        // Arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('onboarding_carousel.json'));
        // Act
        final result = OnboardingCarousel.fromJson(jsonMap);
        // Assert
        expect(result, tOnboardingCarouselModel);
      },
    );
  });
}