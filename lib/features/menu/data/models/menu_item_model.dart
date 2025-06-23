import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:spacemate/features/menu/domain/entities/menu_item_entity.dart';

class MenuItemModel extends MenuItemEntity {
  const MenuItemModel({
    required super.id,
    required super.label,
    super.icon,
    required super.order,
    required super.isVisible,
    required super.isAvailable,
    super.badgeCount,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    int? _parseInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) {
        try {
          return int.parse(value);
        } catch (e) {
          return null;
        }
      }
      return null;
    }

    bool? _parseBool(dynamic value) {
      if (value == null) return null;
      if (value is bool) return value;
      if (value is int) return value == 1;
      if (value is String) {
        if (value.toLowerCase() == 'true' || value == '1') return true;
        if (value.toLowerCase() == 'false' || value == '0') return false;
      }
      return null;
    }



    return MenuItemModel(
      id: _parseInt(json['id']) ?? 0, // Default to 0 if parsing fails
      label: json['label'] as String? ?? json['title'] as String? ?? '', // Handle both 'label' and 'title' from old DB
      icon: json['icon'] as String?,

      order: _parseInt(json['order']) ?? 0,
      isVisible: _parseBool(json['is_visible']) ?? _parseBool(json['isVisible']) ?? false,
      isAvailable: _parseBool(json['is_available']) ?? _parseBool(json['isAvailable']) ?? false,
      badgeCount: _parseInt(json['badge_count']) ?? _parseInt(json['badgeCount']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'icon': icon ?? '',
      'order': order,
      'is_visible': isVisible ? 1 : 0,
      'is_available': isAvailable ? 1 : 0,
      'badge_count': badgeCount,
    };
  }
}
