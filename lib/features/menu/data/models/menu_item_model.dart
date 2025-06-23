import 'package:spacemate/features/menu/domain/entities/menu_item_entity.dart';

class MenuItemModel extends MenuItemEntity {
  const MenuItemModel({
    required int id,
    required String label,
    String? icon,
    required int order,
    required bool isVisible,
    required bool isAvailable,
    int? badgeCount,
  }) : super(
          id: id,
          label: label,
          icon: icon,
          order: order,
          isVisible: isVisible,
          isAvailable: isAvailable,
          badgeCount: badgeCount,
        );

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['id'] as int,
      label: json['label'] as String? ?? json['label'] as String? ?? '', // Handle both 'label' and 'title' from old DB
      icon: json['icon'] as String?,
      order: json['order'] as int? ?? 0,
      isVisible: (json['is_visible'] == 1 || json['isVisible'] == true),
      isAvailable: (json['is_available'] == 1 || json['isAvailable'] == true),
      badgeCount: json['badge_count'] as int? ?? json['badgeCount'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'icon': icon,
      'order': order,
      'is_visible': isVisible ? 1 : 0,
      'is_available': isAvailable ? 1 : 0,
      'badge_count': badgeCount,
    };
  }
}
