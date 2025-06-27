part of 'carousel_bloc.dart';

abstract class CarouselEvent extends Equatable {
  const CarouselEvent();

  @override
  List<Object?> get props => [];
}

class LoadCarousel extends CarouselEvent {
  final String? placeId;

  const LoadCarousel({this.placeId});

  @override
  List<Object?> get props => [placeId];
}
