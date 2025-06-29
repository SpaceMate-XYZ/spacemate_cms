import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:spacemate/features/onboarding/data/models/onboarding_slide.dart';
import 'dart:developer' as developer;

part 'feature.freezed.dart';

@freezed
class Feature with _$Feature {
  const factory Feature({
    required int id,
    required FeatureAttributes attributes,
  }) = _Feature;

  factory Feature.fromJson(Map<String, dynamic> json) {
    try {
      developer.log('Feature: Processing JSON: $json');
      
      final id = json['id'] as num?;
      if (id == null) {
        throw Exception('Feature: id is null');
      }
      
      // Check if the data is directly in the JSON (without attributes wrapper)
      // or if it's wrapped in an 'attributes' field
      Map<String, dynamic> attributesJson;
      if (json.containsKey('attributes')) {
        final attributes = json['attributes'];
        if (attributes == null) {
          throw Exception('Feature: attributes is null');
        }
        if (attributes is! Map<String, dynamic>) {
          throw Exception('Feature: attributes is not a Map: ${attributes.runtimeType}');
        }
        attributesJson = attributes;
      } else {
        // The data is directly in the JSON, treat the whole JSON as attributes
        attributesJson = Map<String, dynamic>.from(json);
        // Remove the id field since it's not part of attributes
        attributesJson.remove('id');
        attributesJson.remove('documentId');
        attributesJson.remove('createdAt');
        attributesJson.remove('updatedAt');
        attributesJson.remove('publishedAt');
        attributesJson.remove('locale');
        attributesJson.remove('localizations');
      }
      
      final attributes = FeatureAttributes.fromJson(attributesJson);
      developer.log('Feature: Successfully processed feature: ${attributes.name}');
      
      return Feature(id: id.toInt(), attributes: attributes);
    } catch (e) {
      developer.log('Feature: Error in fromJson: $e');
      rethrow;
    }
  }
}

@freezed
class FeatureAttributes with _$FeatureAttributes {
  const factory FeatureAttributes({
    @JsonKey(name: 'feature_name') required String name,
    @JsonKey(name: 'onboarding_carousel') List<OnboardingSlide>? onboardingCarousel,
  }) = _FeatureAttributes;

  factory FeatureAttributes.fromJson(Map<String, dynamic> json) {
    try {
      developer.log('FeatureAttributes: Processing JSON: $json');
      
      final name = json['feature_name'] as String?;
      if (name == null) {
        throw Exception('FeatureAttributes: feature_name is null');
      }
      
      final raw = json['onboarding_carousel'];
      developer.log('FeatureAttributes: Raw onboarding_carousel: $raw (type: ${raw.runtimeType})');
      
      List<OnboardingSlide>? onboardingCarousel;
      if (raw == null) {
        onboardingCarousel = null;
        developer.log('FeatureAttributes: onboarding_carousel is null');
      } else if (raw is List) {
        developer.log('FeatureAttributes: Processing onboarding_carousel list with ${raw.length} elements');
        onboardingCarousel = <OnboardingSlide>[];
        
        for (int i = 0; i < raw.length; i++) {
          final element = raw[i];
          developer.log('FeatureAttributes: Processing onboarding element $i: $element (type: ${element.runtimeType})');
          
          if (element == null) {
            developer.log('FeatureAttributes: Skipping null onboarding element at index $i');
            continue;
          }
          
          if (element is! Map<String, dynamic>) {
            developer.log('FeatureAttributes: Skipping non-Map onboarding element at index $i: ${element.runtimeType}');
            continue;
          }
          
          try {
            final slide = OnboardingSlide.fromJson(element);
            onboardingCarousel.add(slide);
            developer.log('FeatureAttributes: Successfully processed onboarding slide: ${slide.title}');
          } catch (e) {
            developer.log('FeatureAttributes: Error processing onboarding slide at index $i: $e');
            // Continue processing other slides
          }
        }
      } else if (raw is Map) {
        // Sometimes Strapi returns an empty object instead of a list
        developer.log('FeatureAttributes: onboarding_carousel is a Map, treating as empty list');
        onboardingCarousel = [];
      } else {
        // Unexpected type, log and treat as empty
        developer.log('FeatureAttributes: Unexpected onboarding_carousel type: ${raw.runtimeType}');
        onboardingCarousel = [];
      }
      
      developer.log('FeatureAttributes: Final onboarding_carousel length: ${onboardingCarousel?.length ?? 0}');
      return FeatureAttributes(
        name: name,
        onboardingCarousel: onboardingCarousel,
      );
    } catch (e) {
      developer.log('FeatureAttributes: Error in fromJson: $e');
      rethrow;
    }
  }
}
