import 'package:equatable/equatable.dart';
import 'package:spacemate/features/menu/domain/entities/menu_item_entity.dart';

/// Base class for all menu events
abstract class MenuEvent extends Equatable {
  const MenuEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load menu items for a specific screen slug.
class LoadMenuEvent extends MenuEvent {
  final String slug;
  final bool forceRefresh;

  const LoadMenuEvent({
    required this.slug,
    this.forceRefresh = false,
  });

  @override
  List<Object?> get props => [slug, forceRefresh];
  
  @override
  String toString() => 'LoadMenuEvent(slug: $slug, forceRefresh: $forceRefresh)';
}

/// Event to refresh the currently loaded menu.
class RefreshMenuEvent extends MenuEvent {
  final String slug;

  const RefreshMenuEvent({
    required this.slug,
  });

  @override
  List<Object?> get props => [slug];
  
  @override
  String toString() => 'RefreshMenuEvent(slug: $slug)';
}

/// Event to clear the menu cache
class ClearMenuCacheEvent extends MenuEvent {
  final String? slug; // If null, clear all caches

  const ClearMenuCacheEvent({this.slug});

  @override
  List<Object?> get props => [slug];
  
  @override
  String toString() => 'ClearMenuCacheEvent(slug: $slug)';
}

/// Event to update menu items
class UpdateMenuItemsEvent extends MenuEvent {
  final String slug;
  final List<MenuItemEntity> items;

  const UpdateMenuItemsEvent({
    required this.slug,
    required this.items,
  });

  @override
  List<Object> get props => [slug, items];
  
  @override
  String toString() => 'UpdateMenuItemsEvent(slug: $slug, items: ${items.length})';
}
