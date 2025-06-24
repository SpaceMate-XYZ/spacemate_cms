import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart'; // Required for debugPrint
import 'package:spacemate/features/menu/data/models/menu_item_model.dart';

class ScreenModel extends Equatable {
  final int id;
  final String name;
  final String slug;
  final String title;
  final List<MenuItemModel> menuGrid;

  const ScreenModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.title,
    required this.menuGrid,
  });

  factory ScreenModel.fromJson(Map<String, dynamic> json) {
    int? _parseInt(dynamic value) {
      if (value is String) {
        debugPrint('ScreenModel: _parseInt received string: $value');
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

    bool? _parseBool(dynamic value) {
      if (value == null) return null;
      if (value is bool) return value;
      if (value is int) return value == 1;
      if (value is String) {
        debugPrint('ScreenModel: _parseBool received string: $value');
        if (value.toLowerCase() == 'true' || value == '1') return true;
        if (value.toLowerCase() == 'false' || value == '0') return false;
      }
      return null;
    }



    final attributes = json['attributes'] as Map<String, dynamic>?;

    // If attributes exist, use them for most fields, otherwise fall back to top-level json
    final source = attributes ?? json;

    return ScreenModel(
      id: _parseInt(json['id']) ?? 0, // ID is typically at the top level
      name: source['name'] as String? ?? '',
      slug: source['slug'] as String? ?? '',
      title: source['title'] as String? ?? '',
      menuGrid: (source['MenuGrid'] != null && source['MenuGrid']['data'] is List)
          ? (source['MenuGrid']['data'] as List)
              .map((item) => MenuItemModel.fromJson(item))
              .toList()
          : [],
    );
  }

  @override
  List<Object?> get props => [id, name, slug, title, menuGrid];
}
