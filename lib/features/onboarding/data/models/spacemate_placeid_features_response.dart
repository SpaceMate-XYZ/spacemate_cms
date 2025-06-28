import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:spacemate/features/onboarding/data/models/feature.dart';

part 'spacemate_placeid_features_response.freezed.dart';
part 'spacemate_placeid_features_response.g.dart';

@freezed
class SpacematePlaceidFeaturesResponse with _$SpacematePlaceidFeaturesResponse {
  const factory SpacematePlaceidFeaturesResponse({
    required List<Feature> data,
  }) = _SpacematePlaceidFeaturesResponse;

  factory SpacematePlaceidFeaturesResponse.fromJson(Map<String, dynamic> json) =>
      _$SpacematePlaceidFeaturesResponseFromJson(json);
}
