import 'package:equatable/equatable.dart';

abstract class MenuEvent extends Equatable {
  const MenuEvent();

  @override
  List<Object?> get props => [];
}

class LoadMenuEvent extends MenuEvent {
  final String placeId;
  final String category;
  final bool forceRefresh;
  final String? locale;

  const LoadMenuEvent({
    required this.placeId,
    required this.category,
    this.forceRefresh = false,
    this.locale,
  });

  @override
  List<Object?> get props => [placeId, category, forceRefresh, locale];
}

class ChangeCategoryEvent extends MenuEvent {
  final String category;

  const ChangeCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

class ChangeLocaleEvent extends MenuEvent {
  final String locale;

  const ChangeLocaleEvent(this.locale);

  @override
  List<Object?> get props => [locale];
}

class RefreshMenuEvent extends MenuEvent {
  final String? category;
  final String? locale;

  const RefreshMenuEvent({this.category, this.locale});

  @override
  List<Object?> get props => [category, locale];
}

class LoadSupportedLocalesEvent extends MenuEvent {
  final String placeId;

  const LoadSupportedLocalesEvent(this.placeId);

  @override
  List<Object?> get props => [placeId];
}
