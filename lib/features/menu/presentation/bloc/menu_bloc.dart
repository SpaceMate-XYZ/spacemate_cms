import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:spacemate/core/error/failures.dart';
import 'package:spacemate/features/menu/domain/usecases/get_menu_items.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_event.dart';
import 'package:spacemate/features/menu/presentation/bloc/menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final GetMenuItems getMenuItems;

  MenuBloc({required this.getMenuItems}) : super(const MenuState()) {
    on<LoadMenuEvent>(_onLoadMenu);
    on<RefreshMenuEvent>(_onRefreshMenu);
  }

  Future<void> _onLoadMenu(LoadMenuEvent event, Emitter<MenuState> emit) async {
    emit(state.copyWith(
      status: MenuStatus.loading,
      slug: event.slug,
      selectedLocale: event.locale,
      clearErrorMessage: true,
    ));

    final result = await getMenuItems(
      GetMenuItemsParams(
        slug: event.slug,
        forceRefresh: event.forceRefresh,
        locale: event.locale,
      ),
    ).run();

    result.match(
      (failure) => emit(state.copyWith(
        status: MenuStatus.failure,
        errorMessage: _mapFailureToMessage(failure),
      )),
      (items) => emit(state.copyWith(
        status: MenuStatus.success,
        items: items,
      )),
    );
  }

  Future<void> _onRefreshMenu(RefreshMenuEvent event, Emitter<MenuState> emit) async {
    add(LoadMenuEvent(
      slug: state.slug,
      forceRefresh: true,
      locale: state.selectedLocale,
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
