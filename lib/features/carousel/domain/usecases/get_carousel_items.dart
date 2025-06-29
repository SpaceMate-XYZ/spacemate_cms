import 'package:dartz/dartz.dart';
import 'package:spacemate/core/error/failures.dart';
import 'package:spacemate/core/usecases/usecase.dart';
import 'package:spacemate/features/carousel/domain/entities/carousel_item_entity.dart';
import 'package:spacemate/features/carousel/domain/repositories/carousel_repository.dart';

class GetCarouselItems implements UseCase<List<CarouselItemEntity>, GetCarouselItemsParams> {
  final CarouselRepository repository;

  const GetCarouselItems(this.repository);

  @override
  Future<Either<Failure, List<CarouselItemEntity>>> call(GetCarouselItemsParams params) async {
    return await repository.getCarouselItems(placeId: params.placeId);
  }
}

class GetCarouselItemsParams {
  final String? placeId;

  GetCarouselItemsParams({this.placeId});
}
