// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_slide.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OnboardingSlideImpl _$$OnboardingSlideImplFromJson(
        Map<String, dynamic> json) =>
    _$OnboardingSlideImpl(
      id: (json['id'] as num).toInt(),
      feature: json['feature'] as String,
      screen: json['screen'] as String,
      title: json['title'] as String,
      imageUrl: json['imageURL'] as String,
      header: json['header'] as String,
      body: json['body'] as String?,
      buttonLabel: json['button_label'] as String?,
    );

Map<String, dynamic> _$$OnboardingSlideImplToJson(
        _$OnboardingSlideImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'feature': instance.feature,
      'screen': instance.screen,
      'title': instance.title,
      'imageURL': instance.imageUrl,
      'header': instance.header,
      'body': instance.body,
      'button_label': instance.buttonLabel,
    };
