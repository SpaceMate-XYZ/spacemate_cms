library carousel_bloc;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:spacemate/core/error/failures.dart';
import 'package:spacemate/features/carousel/domain/entities/carousel_item_entity.dart';
import 'package:spacemate/features/carousel/domain/usecases/get_carousel_items.dart';

part 'carousel_event.dart';
part 'carousel_state.dart';

class CarouselBloc extends Bloc<CarouselEvent, CarouselState> {
  final GetCarouselItems getCarouselItems;

  CarouselBloc({required this.getCarouselItems}) : super(CarouselInitial()) {
    on<LoadCarousel>(_onLoadCarousel);
  }

  Future<void> _onLoadCarousel(
    LoadCarousel event,
    Emitter<CarouselState> emit,
  ) async {
    emit(CarouselLoading());

    final result = await getCarouselItems(
      GetCarouselItemsParams(placeId: event.placeId),
    ).run();

    result.match(
      (failure) {
        emit(CarouselError(message: _mapFailureToMessage(failure)));
      },
      (items) {
        emit(CarouselLoaded(items: items));
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error. Please try again later.';
      case CacheFailure:
        return 'Failed to load carousel items from cache.';
      default:
        return 'Unexpected error occurred.';
    }
  }
}
