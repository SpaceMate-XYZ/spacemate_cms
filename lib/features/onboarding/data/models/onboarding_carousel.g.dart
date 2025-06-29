// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_carousel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OnboardingCarouselImpl _$$OnboardingCarouselImplFromJson(
        Map<String, dynamic> json) =>
    _$OnboardingCarouselImpl(
      slides: (json['slides'] as List<dynamic>)
          .map((e) => OnboardingSlide.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$OnboardingCarouselImplToJson(
        _$OnboardingCarouselImpl instance) =>
    <String, dynamic>{
      'slides': instance.slides,
    };
