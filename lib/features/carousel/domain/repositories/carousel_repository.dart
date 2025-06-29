import 'package:dartz/dartz.dart';
import 'package:spacemate/core/error/failures.dart';
import 'package:spacemate/features/carousel/domain/entities/carousel_item_entity.dart';

abstract class CarouselRepository {
  /// Fetches carousel items from the remote data source
  /// 
  /// [placeId] - Optional filter for place-specific carousel items
  /// Returns [List<CarouselItemEntity>] on success or [Failure] on error
  Future<Either<Failure, List<CarouselItemEntity>>> getCarouselItems({
    String? placeId,
  });

  /// Fetches a specific carousel item by ID
  /// 
  /// [id] - The ID of the carousel item to fetch
  /// Returns [CarouselItemEntity] on success or [Failure] on error
  Future<Either<Failure, CarouselItemEntity>> getCarouselItemById(String id);
}
