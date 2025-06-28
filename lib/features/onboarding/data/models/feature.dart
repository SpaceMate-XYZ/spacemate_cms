import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:spacemate/features/onboarding/data/models/onboarding_slide.dart';

part 'feature.freezed.dart';
part 'feature.g.dart';

@freezed
class Feature with _$Feature {
  const factory Feature({
    required int id,
    required FeatureAttributes attributes,
  }) = _Feature;

  factory Feature.fromJson(Map<String, dynamic> json) =>
      _$FeatureFromJson(json);
}

@freezed
class FeatureAttributes with _$FeatureAttributes {
  const factory FeatureAttributes({
    @JsonKey(name: 'feature_name') required String name,
    @JsonKey(name: 'onboarding_carousel') List<OnboardingSlide>? onboardingCarousel,
  }) = _FeatureAttributes;

  factory FeatureAttributes.fromJson(Map<String, dynamic> json) =>
      _$FeatureAttributesFromJson(json);
}
