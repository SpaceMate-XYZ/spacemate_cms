import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:spacemate/core/error/failures.dart';
import 'package:spacemate/core/usecases/usecase.dart';
import 'package:spacemate/features/menu/domain/entities/menu_item_entity.dart';
import 'package:spacemate/features/menu/domain/usecases/get_menu_items.dart';
import 'package:spacemate/features/menu/domain/usecases/get_supported_locales.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_event.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_state.dart';

/// Default place ID to use when none is provided
const String defaultPlaceId = 'default_place_id';

/// Business Logic Component for managing menu state
class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final GetMenuItems getMenuItems;
  final GetSupportedLocales getSupportedLocales;

  MenuBloc({
    required this.getMenuItems,
    required this.getSupportedLocales,
  }) : super(const MenuState()) {
    on<LoadMenuEvent>(_onLoadMenu);
    on<ChangeCategoryEvent>(_onChangeCategory);
    on<ChangeLocaleEvent>(_onChangeLocale);
    on<RefreshMenuEvent>(_onRefreshMenu);
    on<LoadSupportedLocalesEvent>(_onLoadSupportedLocales);
  }

  Future<void> _onRefreshMenu(
    RefreshMenuEvent event,
    Emitter<MenuState> emit,
  ) async {
    final placeId = state.placeId ?? defaultPlaceId;
    final category = event.category ?? state.category ?? 'home';
    final locale = event.locale ?? state.selectedLocale;
    
    add(LoadMenuEvent(
      placeId: placeId,
      category: category,
      forceRefresh: true,
      locale: locale,
    ));
  }

  Future<void> _onLoadMenu(
    LoadMenuEvent event,
    Emitter<MenuState> emit,
  ) async {
    try {
      // First update the state with loading status and new placeId
      emit(state.copyWith(
        status: MenuStatus.loading,
        placeId: event.placeId,
        category: null, // Don't set category in loading state
        selectedLocale: event.locale,
      ));
      
      final result = await getMenuItems(
        GetMenuItemsParams(
          placeId: event.placeId,
          category: event.category,
          forceRefresh: event.forceRefresh,
          locale: event.locale,
        ),
      ).run();

      result.match(
        (failure) => emit(
          state.copyWith(
            status: MenuStatus.failure,
            errorMessage: _mapFailureToMessage(failure),
            placeId: event.placeId,
            category: null, // Don't set category on error
          ),
        ),
        (items) => emit(
          state.copyWith(
            status: MenuStatus.success,
            items: items,
            placeId: event.placeId,
            category: event.category,
            selectedLocale: event.locale,
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: MenuStatus.failure,
          errorMessage: 'An unexpected error occurred',
          placeId: event.placeId,
          category: null, // Don't set category on error
        ),
      );
    }
  }

  FutureOr<void> _onChangeCategory(
    ChangeCategoryEvent event,
    Emitter<MenuState> emit,
  ) {
    final placeId = state.placeId ?? defaultPlaceId;
    
    add(LoadMenuEvent(
      placeId: placeId,
      category: event.category,
      locale: state.selectedLocale,
    ));
  }

  Future<void> _onChangeLocale(
    ChangeLocaleEvent event,
    Emitter<MenuState> emit,
  ) async {
    if (state.placeId == null) return;

    final placeId = state.placeId!;
    final category = state.category ?? 'home';
    
    try {
      // Update the locale in the state immediately
      emit(state.copyWith(
        selectedLocale: event.locale,
        status: MenuStatus.loading,
      ));

      // Then load the menu items with the new locale
      final result = await getMenuItems(
        GetMenuItemsParams(
          placeId: placeId,
          category: category,
          forceRefresh: false, // Match test expectation
          locale: event.locale,
        ),
      ).run();

      result.match(
        (failure) => emit(
          state.copyWith(
            status: MenuStatus.failure,
            errorMessage: _mapFailureToMessage(failure),
            placeId: placeId,
            category: category,
            selectedLocale: event.locale,
          ),
        ),
        (items) => emit(
          state.copyWith(
            status: MenuStatus.success,
            items: items,
            placeId: placeId,
            category: category,
            selectedLocale: event.locale,
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: MenuStatus.failure,
          errorMessage: 'An unexpected error occurred',
          placeId: placeId,
          category: category,
          selectedLocale: event.locale,
        ),
      );
    }
  }

  Future<void> _onLoadSupportedLocales(
    LoadSupportedLocalesEvent event,
    Emitter<MenuState> emit,
  ) async {
    try {
      final result = await getSupportedLocales(
        GetSupportedLocalesParams(placeId: event.placeId),
      ).run();

      result.match(
        (failure) => emit(state.copyWith(
          errorMessage: _mapFailureToMessage(failure),
        )),
        (locales) => emit(state.copyWith(
          supportedLocales: locales,
          selectedLocale: locales.isNotEmpty ? locales.first : null,
        )),
      );
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: 'Failed to load supported locales',
        ),
      );
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error';
      case CacheFailure:
        return 'Cache error';
      case NetworkFailure:
        return 'No internet connection';
      default:
        return 'Unexpected error';
    }
  }
}
