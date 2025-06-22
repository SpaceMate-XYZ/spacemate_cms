import 'package:equatable/equatable.dart';
import 'package:spacemate/features/menu/domain/entities/menu_item_entity.dart';

enum MenuStatus { initial, loading, success, failure }

class MenuState extends Equatable {
  final MenuStatus status;
  final List<MenuItemEntity> items;
  final String? errorMessage;
  final String? category;
  final String? placeId;
  final String? selectedLocale;
  final List<String>? supportedLocales;

  const MenuState({
    this.status = MenuStatus.initial,
    this.items = const [],
    this.errorMessage,
    this.category,
    this.placeId,
    this.selectedLocale,
    this.supportedLocales,
  });

  MenuState copyWith({
    MenuStatus? status,
    List<MenuItemEntity>? items,
    String? errorMessage,
    String? category,
    String? placeId,
    String? selectedLocale,
    List<String>? supportedLocales,
  }) {
    return MenuState(
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage: errorMessage,
      category: category ?? this.category,
      placeId: placeId ?? this.placeId,
      selectedLocale: selectedLocale ?? this.selectedLocale,
      supportedLocales: supportedLocales ?? this.supportedLocales,
    );
  }

  @override
  List<Object?> get props => [
        status,
        items,
        errorMessage,
        category,
        placeId,
        selectedLocale,
        supportedLocales,
      ];
}
