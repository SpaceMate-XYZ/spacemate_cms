import 'package:equatable/equatable.dart';
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
    return ScreenModel(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      title: json['title'],
      menuGrid: (json['MenuGrid'] as List)
          .map((item) => MenuItemModel.fromJson(item))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [id, name, slug, title, menuGrid];
}
