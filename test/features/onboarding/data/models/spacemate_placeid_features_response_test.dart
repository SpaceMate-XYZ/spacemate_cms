import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:spacemate/features/onboarding/data/models/feature.dart';
import 'package:spacemate/features/onboarding/data/models/onboarding_carousel.dart';
import 'package:spacemate/features/onboarding/data/models/onboarding_slide.dart';
import 'package:spacemate/features/onboarding/data/models/spacemate_placeid_features_response.dart';

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

  const tOnboardingCarouselModel = OnboardingCarousel(
    slides: [
      tOnboardingSlideModel,
    ],
  );

  const tFeatureAttributes = FeatureAttributes(
    name: 'Parking',
    onboardingCarousel: tOnboardingCarouselModel,
  );

  const tFeatureModel = Feature(
    id: 1,
    attributes: tFeatureAttributes,
  );

  const tFeatureAttributes2 = FeatureAttributes(
    name: 'Another Feature',
    onboardingCarousel: null,
  );

  const tFeatureModel2 = Feature(
    id: 2,
    attributes: tFeatureAttributes2,
  );

  const tSpacematePlaceidFeaturesResponse = SpacematePlaceidFeaturesResponse(
    data: [
      tFeatureModel,
      tFeatureModel2,
    ],
  );

  group('SpacematePlaceidFeaturesResponse', () {
    test(
      'should return a valid model when the JSON is parsed',
      () async {
        // Arrange
        final Map<String, dynamic> jsonMap = json
            .decode(fixture('spacemate_placeid_features_response.json'));
        // Act
        final result = SpacematePlaceidFeaturesResponse.fromJson(jsonMap);
        // Assert
        expect(result, tSpacematePlaceidFeaturesResponse);
      },
    );
  });
}