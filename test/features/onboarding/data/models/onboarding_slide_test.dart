import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:spacemate/features/onboarding/data/models/onboarding_slide.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final Map<String, dynamic> tOnboardingSlideJson = {
    'id': 1,
    'feature': 'Parking',
    'screen': '1',
    'title': 'Welcome to Parking',
    'imageUrl': 'https://example.com/image1.png',
    'header': 'Find your perfect spot',
    'body': 'Easily locate and reserve parking spaces.',
    'buttonLabel': null,
  };

  const tOnboardingSlide = OnboardingSlide(
    id: 1,
    feature: 'Parking',
    screen: '1',
    title: 'Welcome to Parking',
    imageUrl: 'https://example.com/image1.png',
    header: 'Find your perfect spot',
    body: 'Easily locate and reserve parking spaces.',
    buttonLabel: null,
  );

  group('OnboardingSlide', () {
    test(
      'should be a subclass of OnboardingSlide entity',
      () async {
        expect(tOnboardingSlide, isA<OnboardingSlide>());
      },
    );

    test(
      'should return a valid model when the JSON is parsed',
      () async {
        // Arrange
        final Map<String, dynamic> jsonMap = json.decode(fixture('onboarding_slide.json'));
        // Act
        final result = OnboardingSlide.fromJson(jsonMap);
        // Assert
        expect(result, tOnboardingSlide);
      },
    );
  });
}
