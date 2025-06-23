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



    return ScreenModel(
      id: _parseInt(json['id']) ?? 0,
      name: json['name'],
      slug: json['slug'],
      title: json['title'],
      menuGrid: (json['MenuGrid'] != null && json['MenuGrid']['data'] is List)
          ? (json['MenuGrid']['data'] as List)
              .map((item) => MenuItemModel.fromJson(item))
              .toList()
          : [],
    );
  }

  @override
  List<Object?> get props => [id, name, slug, title, menuGrid];
}
