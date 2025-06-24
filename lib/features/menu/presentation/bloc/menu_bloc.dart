import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacemate/core/error/failures.dart';
import 'package:spacemate/features/menu/domain/entities/menu_category.dart';
import 'package:spacemate/features/menu/domain/entities/menu_item_entity.dart';
import 'package:spacemate/features/menu/domain/usecases/get_menu_items.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_event.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final GetMenuItems getMenuItems;
  
  // Cache for each category's menu items
  final Map<String, List<MenuItemEntity>> _menuCache = {};
  final Map<String, bool> _isLoading = {};
  final Map<String, String?> _errorMessages = {};

  MenuBloc({required this.getMenuItems}) : super(const MenuState.initial()) {
    on<LoadMenuEvent>(_onLoadMenu);
    on<RefreshMenuEvent>(_onRefreshMenu);
    
    // Initialize loading states for all categories
    for (final category in MenuCategory.values) {
      _isLoading[category.name] = false;
      _errorMessages[category.name] = null;
    }
  }

  Future<void> _onLoadMenu(LoadMenuEvent event, Emitter<MenuState> emit) async {
    final slug = event.slug;

    
    // Skip if already loading this category
    if (_isLoading[slug] == true && !event.forceRefresh) {

      return;
    }

    // Update loading state
    _isLoading[slug] = true;
    _errorMessages[slug] = null;
    
    // Emit loading state with current items if available
    emit(state.copyWith(
      status: MenuStatus.loading,
      items: _menuCache[slug] ?? [],
      errorMessage: null,
    ));


    try {
      final result = getMenuItems(GetMenuItemsParams(slug: slug));
      
      // Handle the result by explicitly running the TaskEither
      (await result.run()).match(
        (failure) {
          _errorMessages[slug] = failure.message;
          emit(state.copyWith(
            status: MenuStatus.failure,
            errorMessage: failure.message,
            items: _menuCache[slug] ?? [],
          ));
        },
        (items) {
          try {
            // Update cache
            _menuCache[slug] = items ?? [];
            emit(state.copyWith(
              status: MenuStatus.success,
              items: items ?? [],
              errorMessage: null,
            ));
          } catch (e) {
            _errorMessages[slug] = 'Failed to process menu items: $e';
            emit(state.copyWith(
              status: MenuStatus.failure,
              errorMessage: 'Failed to process menu items: $e',
              items: _menuCache[slug] ?? [],
            ));
          }
        },
      );
    } catch (e) {
      _errorMessages[slug] = 'An unexpected error occurred';
      emit(state.copyWith(
        status: MenuStatus.failure,
        errorMessage: 'An unexpected error occurred: $e',
        items: _menuCache[slug] ?? [],
      ));

    } finally {
      _isLoading[slug] = false;

    }
  }
  
  // Helper method to get current state for a specific category
  MenuState getStateForCategory(String slug) {
    return state.copyWith(
      items: _menuCache[slug] ?? [],
      status: _isLoading[slug] == true 
          ? MenuStatus.loading 
          : (_errorMessages[slug] != null ? MenuStatus.failure : MenuStatus.success),
      errorMessage: _errorMessages[slug],
    );
  }

  Future<void> _onRefreshMenu(RefreshMenuEvent event, Emitter<MenuState> emit) async {
    // Force reload the current category
    add(LoadMenuEvent(
      slug: event.slug,
      forceRefresh: true,
    ));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server Error: ${failure.message}';
      case CacheFailure:
        return 'Cache Error: ${failure.message}';
      case NetworkFailure:
        return 'Network Error: Please check your connection.';
      default:
        return 'An unexpected error occurred.';
    }
  }
}
