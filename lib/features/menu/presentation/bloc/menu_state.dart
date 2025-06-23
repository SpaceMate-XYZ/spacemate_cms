import 'package:equatable/equatable.dart';
import 'package:spacemate/features/menu/domain/entities/menu_item_entity.dart';

enum MenuStatus { initial, loading, success, failure }

class MenuState extends Equatable {
  final MenuStatus status;
  final List<MenuItemEntity> items;
  final String? errorMessage;
  final String slug;
  final String? selectedLocale;

  const MenuState({
    this.status = MenuStatus.initial,
    this.items = const [],
    this.errorMessage,
    this.slug = 'home', // Default slug
    this.selectedLocale,
  });

  MenuState copyWith({
    MenuStatus? status,
    List<MenuItemEntity>? items,
    String? errorMessage,
    String? slug,
    String? selectedLocale,
    bool clearErrorMessage = false,
  }) {
    return MenuState(
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
      slug: slug ?? this.slug,
      selectedLocale: selectedLocale ?? this.selectedLocale,
    );
  }

  @override
  List<Object?> get props => [
        status,
        items,
        errorMessage,
        slug,
        selectedLocale,
      ];
}
