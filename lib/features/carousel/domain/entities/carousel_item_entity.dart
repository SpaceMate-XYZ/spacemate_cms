import 'package:equatable/equatable.dart';

class CarouselItemEntity extends Equatable {
  final String id;
  final String title;
  final String? description;
  final String imageUrl;
  final String? actionText;
  final String? actionRoute;
  final int order;
  final bool isActive;
  final String? placeId;

  const CarouselItemEntity({
    required this.id,
    required this.title,
    this.description,
    required this.imageUrl,
    this.actionText,
    this.actionRoute,
    this.order = 0,
    this.isActive = true,
    this.placeId,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        imageUrl,
        actionText,
        actionRoute,
        order,
        isActive,
        placeId,
      ];

  CarouselItemEntity copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    String? actionText,
    String? actionRoute,
    int? order,
    bool? isActive,
    String? placeId,
  }) {
    return CarouselItemEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      actionText: actionText ?? this.actionText,
      actionRoute: actionRoute ?? this.actionRoute,
      order: order ?? this.order,
      isActive: isActive ?? this.isActive,
      placeId: placeId ?? this.placeId,
    );
  }
}
