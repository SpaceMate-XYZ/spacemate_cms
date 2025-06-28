import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:spacemate/features/onboarding/data/models/onboarding_slide.dart';

part 'onboarding_carousel.freezed.dart';
part 'onboarding_carousel.g.dart';

@freezed
class OnboardingCarousel with _$OnboardingCarousel {
  const factory OnboardingCarousel({
    required List<OnboardingSlide> slides,
  }) = _OnboardingCarousel;

  factory OnboardingCarousel.fromJson(Map<String, dynamic> json) =>
      _$OnboardingCarouselFromJson(json);
}