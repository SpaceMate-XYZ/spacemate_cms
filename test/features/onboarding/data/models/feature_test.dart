import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:spacemate/features/onboarding/data/models/feature.dart';
import 'package:spacemate/features/onboarding/data/models/onboarding_carousel.dart';
import 'package:spacemate/features/onboarding/data/models/onboarding_slide.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tOnboardingSlideModel = OnboardingSlide(
    id: 1,
    feature: 'Parking',
    screen: '1',
    title: 'Welcome to Parking',
    imageUrl: 'https://example.com/image1.png',
    header: 'Find your perfect spot',
    body: 'Easily locate and reserve parking spaces.',
    buttonLabel: null,
  );

  const tFeatureAttributes = FeatureAttributes(
    name: 'Parking',
    onboardingCarousel: [tOnboardingSlideModel],
  );

  const tFeatureModel = Feature(
    id: 1,
    attributes: tFeatureAttributes,
  );

  group('Feature', () {
    test(
      'should return a valid model when the JSON is parsed',
      () async {
        // Arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('feature.json'));
        // Act
        final result = Feature.fromJson(jsonMap);
        // Assert
        expect(result, tFeatureModel);
      },
    );
  });
}