import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:spacemate/features/onboarding/data/models/feature.dart';
import 'dart:developer' as developer;

part 'spacemate_placeid_features_response.freezed.dart';

@freezed
class SpacematePlaceidFeaturesResponse with _$SpacematePlaceidFeaturesResponse {
  const factory SpacematePlaceidFeaturesResponse({
    required List<Feature> data,
  }) = _SpacematePlaceidFeaturesResponse;

  factory SpacematePlaceidFeaturesResponse.fromJson(Map<String, dynamic> json) {
    try {
      developer.log('SpacematePlaceidFeaturesResponse: Processing JSON: $json');
      
      final rawData = json['data'] as List<dynamic>? ?? [];
      developer.log('SpacematePlaceidFeaturesResponse: Raw data length: ${rawData.length}');
      
      final data = <Feature>[];
      for (int i = 0; i < rawData.length; i++) {
        final element = rawData[i];
        developer.log('SpacematePlaceidFeaturesResponse: Processing element $i: $element (type: ${element.runtimeType})');
        
        if (element == null) {
          developer.log('SpacematePlaceidFeaturesResponse: Skipping null element at index $i');
          continue;
        }
        
        if (element is! Map<String, dynamic>) {
          developer.log('SpacematePlaceidFeaturesResponse: Skipping non-Map element at index $i: ${element.runtimeType}');
          continue;
        }
        
        try {
          final feature = Feature.fromJson(element);
          data.add(feature);
          developer.log('SpacematePlaceidFeaturesResponse: Successfully processed feature: ${feature.attributes.name}');
        } catch (e) {
          developer.log('SpacematePlaceidFeaturesResponse: Error processing feature at index $i: $e');
          // Continue processing other features
        }
      }
      
      developer.log('SpacematePlaceidFeaturesResponse: Final data length: ${data.length}');
      return SpacematePlaceidFeaturesResponse(data: data);
    } catch (e) {
      developer.log('SpacematePlaceidFeaturesResponse: Error in fromJson: $e');
      rethrow;
    }
  }
}
