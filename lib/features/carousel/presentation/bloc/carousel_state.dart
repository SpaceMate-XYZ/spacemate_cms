part of 'carousel_bloc.dart';

abstract class CarouselState extends Equatable {
  const CarouselState();

  @override
  List<Object?> get props => [];
}

class CarouselInitial extends CarouselState {}

class CarouselLoading extends CarouselState {}

class CarouselLoaded extends CarouselState {
  final List<CarouselItemEntity> items;

  const CarouselLoaded({required this.items});

  @override
  List<Object?> get props => [items];
}

class CarouselError extends CarouselState {
  final String message;

  const CarouselError({required this.message});

  @override
  List<Object?> get props => [message];
}
