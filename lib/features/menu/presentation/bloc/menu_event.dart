import 'package:equatable/equatable.dart';

abstract class MenuEvent extends Equatable {
  const MenuEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load menu items for a specific screen slug.
class LoadMenuEvent extends MenuEvent {
  final String slug;
  final bool forceRefresh;
  final String? locale;

  const LoadMenuEvent({
    required this.slug,
    this.forceRefresh = false,
    this.locale,
  });

  @override
  List<Object?> get props => [slug, forceRefresh, locale];
}

/// Event to refresh the currently loaded menu.
class RefreshMenuEvent extends MenuEvent {}
