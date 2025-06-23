import 'package:equatable/equatable.dart';
import 'package:spacemate/features/menu/domain/entities/menu_item_entity.dart';

enum MenuStatus { initial, loading, success, failure }

class MenuState extends Equatable {
  final MenuStatus status;
  final List<MenuItemEntity> items;
  final String? errorMessage;
  final String? selectedLocale;
  final String slug;

  const MenuState({
    this.status = MenuStatus.initial,
    this.items = const [],
    this.errorMessage,
    this.selectedLocale,
    this.slug = 'home',
  });

  // Factory for initial state
  const MenuState.initial() : this();

  // Factory for loading state
  const MenuState.loading({required this.slug, this.items = const []}) 
    : status = MenuStatus.loading,
      errorMessage = null,
      selectedLocale = null;

  // Factory for success state
  const MenuState.success({
    required this.items,
    this.slug = 'home',
  })  : status = MenuStatus.success,
        errorMessage = null,
        selectedLocale = null;

  // Factory for failure state
  const MenuState.failure({
    required String message,
    this.items = const [],
    this.slug = 'home',
  })  : status = MenuStatus.failure,
        errorMessage = message,
        selectedLocale = null;

  MenuState copyWith({
    MenuStatus? status,
    List<MenuItemEntity>? items,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? selectedLocale,
    String? slug,
  }) {
    return MenuState(
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      selectedLocale: selectedLocale ?? this.selectedLocale,
      slug: slug ?? this.slug,
    );
  }

  bool get isLoading => status == MenuStatus.loading;
  bool get isSuccess => status == MenuStatus.success;
  bool get isFailure => status == MenuStatus.failure;
  bool get hasError => errorMessage != null;

  @override
  List<Object?> get props => [status, items, errorMessage, selectedLocale, slug];
  
  @override
  String toString() {
    return 'MenuState(status: $status, items: ${items.length}, error: $errorMessage, slug: $slug)';
  }
}
