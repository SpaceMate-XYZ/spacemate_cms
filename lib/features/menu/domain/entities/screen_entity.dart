import 'package:equatable/equatable.dart';
import 'package:spacemate/features/menu/domain/entities/menu_item_entity.dart';

class ScreenEntity extends Equatable {
  final int id;
  final String name;
  final String slug;
  final String title;
  final List<MenuItemEntity> menuGrid;

  const ScreenEntity({
    required this.id,
    required this.name,
    required this.slug,
    required this.title,
    required this.menuGrid,
  });

  @override
  List<Object?> get props => [id, name, slug, title, menuGrid];
}
