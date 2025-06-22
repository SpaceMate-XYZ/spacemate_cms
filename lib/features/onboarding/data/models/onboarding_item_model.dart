import 'package:json_annotation/json_annotation.dart';

part 'onboarding_item_model.g.dart';

@JsonSerializable()
class OnboardingItemModel {
  final int id;
  final String title;
  final String description;
  final String imageUrl;
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
