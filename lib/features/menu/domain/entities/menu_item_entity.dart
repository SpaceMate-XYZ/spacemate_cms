import 'package:equatable/equatable.dart';
import 'package:spacemate/features/menu/domain/entities/menu_category.dart';

class MenuItemEntity extends Equatable {
  final String id;
  final String title;
  final String icon;
  final MenuCategory category;
  final String route;
  final bool isActive;
  final int? order;
  final int badgeCount;
  final List<String> requiredPermissions;
  final String analyticsId;
  final String? imageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const MenuItemEntity({
    required this.id,
    required this.title,
    required this.icon,
    required this.category,
    required this.route,
    this.isActive = true,
    this.order,
    this.badgeCount = 0,
    this.requiredPermissions = const [],
    required this.analyticsId,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        icon,
        category,
        route,
        isActive,
        order,
        badgeCount,
        requiredPermissions,
        analyticsId,
        imageUrl,
      ];

  MenuItemEntity copyWith({
    String? id,
    String? title,
    String? icon,
    MenuCategory? category,
    String? route,
    bool? isActive,
    int? order,
    int? badgeCount,
    List<String>? requiredPermissions,
    String? analyticsId,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MenuItemEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      category: category ?? this.category,
      route: route ?? this.route,
      isActive: isActive ?? this.isActive,
      order: order ?? this.order,
      badgeCount: badgeCount ?? this.badgeCount,
      requiredPermissions: requiredPermissions ?? this.requiredPermissions,
      analyticsId: analyticsId ?? this.analyticsId,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
