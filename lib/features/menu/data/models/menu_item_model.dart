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
    super.navigationTarget,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    int? parseInt(dynamic value) {
      if (value is String) {
        debugPrint('MenuItemModel: _parseInt received string: $value');
      }

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

    bool? parseBool(dynamic value) {
      if (value is String) {
        debugPrint('MenuItemModel: _parseBool received string: $value');
      }

      if (value == null) return null;
      if (value is bool) return value;
      if (value is int) return value == 1;
      if (value is String) {
        if (value.toLowerCase() == 'true' || value == '1') return true;
        if (value.toLowerCase() == 'false' || value == '0') return false;
      }
      return null;
    }



    final attributes = json['attributes'] as Map<String, dynamic>?;

    // If attributes exist, use them for most fields, otherwise fall back to top-level json
    final source = attributes ?? json;

    return MenuItemModel(
      id: parseInt(json['id']) ?? 0, // ID is typically at the top level
      label: source['label'] as String? ?? source['title'] as String? ?? '', // Handle both 'label' and 'title' from old DB
      icon: source['icon'] as String?,

      order: parseInt(source['order']) ?? 0,
      isVisible: parseBool(source['is_visible']) ?? parseBool(source['isVisible']) ?? false,
      isAvailable: parseBool(source['is_available']) ?? parseBool(source['isAvailable']) ?? false,
      badgeCount: parseInt(source['badge_count']) ?? parseInt(source['badgeCount']),
      navigationTarget: source['navigationTarget'] as String?,
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
      'navigationTarget': navigationTarget,
    };
  }
}
