// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spacemate_placeid_features_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SpacematePlaceidFeaturesResponseImpl
    _$$SpacematePlaceidFeaturesResponseImplFromJson(
            Map<String, dynamic> json) =>
        _$SpacematePlaceidFeaturesResponseImpl(
          data: (json['data'] as List<dynamic>)
              .map((e) => Feature.fromJson(e as Map<String, dynamic>))
              .toList(),
        );

Map<String, dynamic> _$$SpacematePlaceidFeaturesResponseImplToJson(
        _$SpacematePlaceidFeaturesResponseImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
