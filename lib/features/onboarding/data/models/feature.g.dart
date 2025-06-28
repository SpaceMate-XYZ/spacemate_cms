// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feature.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FeatureImpl _$$FeatureImplFromJson(Map<String, dynamic> json) =>
    _$FeatureImpl(
      id: (json['id'] as num).toInt(),
      attributes: FeatureAttributes.fromJson(
          json['attributes'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$FeatureImplToJson(_$FeatureImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'attributes': instance.attributes,
    };

_$FeatureAttributesImpl _$$FeatureAttributesImplFromJson(
        Map<String, dynamic> json) =>
    _$FeatureAttributesImpl(
      name: json['feature_name'] as String,
      onboardingCarousel: (json['onboarding_carousel'] as List<dynamic>?)
          ?.map((e) => OnboardingSlide.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$FeatureAttributesImplToJson(
        _$FeatureAttributesImpl instance) =>
    <String, dynamic>{
      'feature_name': instance.name,
      'onboarding_carousel': instance.onboardingCarousel,
    };
