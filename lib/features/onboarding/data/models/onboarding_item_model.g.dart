// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OnboardingItemModel _$OnboardingItemModelFromJson(Map<String, dynamic> json) =>
    OnboardingItemModel(
      id: _parseInt(json['id']),
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      order: _parseInt(json['order']),
    );

Map<String, dynamic> _$OnboardingItemModelToJson(
        OnboardingItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'order': instance.order,
    };
