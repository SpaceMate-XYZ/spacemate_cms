import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'onboarding_slide.freezed.dart';
part 'onboarding_slide.g.dart';

@freezed
class OnboardingSlide with _$OnboardingSlide {
  const factory OnboardingSlide({
    required int id,
    required String feature,
    required int screen,
    required String title,
    @JsonKey(name: 'imageURL') required String imageUrl,
    required String header,
    required String body,
    @JsonKey(name: 'button_label') String? buttonLabel,
  }) = _OnboardingSlide;

  factory OnboardingSlide.fromJson(Map<String, dynamic> json) =>
      _$OnboardingSlideFromJson(json);
}
