import 'package:fpdart/fpdart.dart';
import 'package:spacemate/core/error/failures.dart';
import 'package:spacemate/core/network/dio_client.dart';
import 'package:spacemate/core/network/network_info.dart';
import 'package:spacemate/features/carousel/data/models/strapi_carousel_model.dart';
import 'package:spacemate/features/carousel/domain/entities/carousel_item_entity.dart';
import 'package:spacemate/features/carousel/domain/repositories/carousel_repository.dart';

class StrapiCarouselRepository implements CarouselRepository {
  final DioClient httpClient;
  final NetworkInfo networkInfo;
  final String baseUrl;

  StrapiCarouselRepository({
    required this.httpClient,
    required this.networkInfo,
    this.baseUrl = 'https://strapi.apps.rredu.in/api',
  });

  @override
  TaskEither<Failure, List<CarouselItemEntity>> getCarouselItems({
    String? placeId,
  }) {
    return TaskEither.tryCatch(
      () async {
        if (!await networkInfo.isConnected) {
          throw const NetworkFailure();
        }

        final response = await httpClient.dio.get(
          '$baseUrl/spacemate-placeid-features',
          queryParameters: {
            'populate': '*',
            if (placeId != null) r'filters[placeId][$eq]': placeId,
            'sort': 'order:asc',
          },
        );

        final responseData = response.data as Map<String, dynamic>;
        final carouselResponse = StrapiCarouselResponse.fromJson(responseData);
        return carouselResponse.data
            .where((item) => item.attributes.isActive)
            .map((item) => item.toEntity())
            .toList();
      },
      (error, stackTrace) => error is Failure 
          ? error 
          : ServerFailure(error.toString()),
    );
  }

  @override
  TaskEither<Failure, CarouselItemEntity> getCarouselItemById(String id) {
    return TaskEither.tryCatch(
      () async {
        if (!await networkInfo.isConnected) {
          throw const NetworkFailure();
        }

        final response = await httpClient.dio.get(
          '$baseUrl/spacemate-placeid-features/$id',
          queryParameters: {
            'populate': '*',
          },
        );

        final responseData = response.data as Map<String, dynamic>;
        final item = StrapiCarouselItem.fromJson(
          responseData['data'] as Map<String, dynamic>,
        );

        return item.toEntity();
      },
      (error, stackTrace) => error is Failure 
          ? error 
          : ServerFailure(error.toString()),
    );
  }
}

extension StrapiCarouselItemX on StrapiCarouselItem {
  CarouselItemEntity toEntity() {
    return CarouselItemEntity(
      id: id.toString(),
      title: attributes.title,
      description: attributes.description,
      imageUrl: _getImageUrl(attributes.image),
      actionText: attributes.actionText,
      actionRoute: attributes.actionRoute,
      order: attributes.order,
      isActive: attributes.isActive,
      placeId: attributes.placeId,
    );
  }

  String _getImageUrl(StrapiImage? image) {
    if (image == null) return '';
    
    // Get the best available image size
    final url = image.largeUrl ?? image.mediumUrl ?? image.smallUrl ?? image.url;
    
    // If the URL is already absolute, return it
    if (url.startsWith('http')) {
      return url;
    }
    
    // Otherwise, construct the full URL
    final baseUrl = 'https://strapi.apps.rredu.in';
    return url.startsWith('/') ? '$baseUrl$url' : '$baseUrl/$url';
  }
}
