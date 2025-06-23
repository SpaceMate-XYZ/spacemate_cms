import 'package:json_annotation/json_annotation.dart';

part 'onboarding_item_model.g.dart';

int _parseInt(dynamic value) {
  if (value is int) return value;
  if (value is String) {
    try {
      return int.parse(value);
    } catch (e) {
      // Handle parsing error, e.g., log it or return a default value
      return 0; // Default to 0 if parsing fails
    }
  }
  return 0; // Default to 0 for other types or null
}

@JsonSerializable()
class OnboardingItemModel {
  @JsonKey(fromJson: _parseInt)
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  @JsonKey(fromJson: _parseInt)
  final int order;

  OnboardingItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.order,
  });

  factory OnboardingItemModel.fromJson(Map<String, dynamic> json) =>
      _$OnboardingItemModelFromJson(json);
      
  Map<String, dynamic> toJson() => _$OnboardingItemModelToJson(this);
}
