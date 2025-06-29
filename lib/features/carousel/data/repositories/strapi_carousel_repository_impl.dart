import 'package:dartz/dartz.dart';
import 'package:spacemate/core/error/exceptions.dart';
import 'package:spacemate/core/error/failures.dart';
import 'package:spacemate/core/network/dio_client.dart';
import 'package:spacemate/core/network/network_info.dart';
import 'package:spacemate/core/config/app_config.dart';
import 'package:spacemate/features/carousel/data/models/strapi_carousel_model.dart';
import 'package:spacemate/features/carousel/domain/entities/carousel_item_entity.dart';
import 'package:spacemate/features/carousel/domain/repositories/carousel_repository.dart';
import 'dart:developer' as developer;

class StrapiCarouselRepositoryImpl implements CarouselRepository {
  final DioClient dioClient;
  late final String baseUrl;
  final NetworkInfo networkInfo;

  StrapiCarouselRepositoryImpl({
    required this.dioClient,
    required this.networkInfo,
  }) {
    // Initialize with the carousel Strapi URL from config
    baseUrl = AppConfig.carouselStrapiBaseUrl;
  }

  @override
  Future<Either<Failure, List<CarouselItemEntity>>> getCarouselItems({String? placeId}) async {
    try {
      developer.log('StrapiCarouselRepositoryImpl: Fetching carousel items for placeId: $placeId');
      
      if (await networkInfo.isConnected) {
        final queryParams = <String, dynamic>{
          'populate': '*',
        };
        
        if (placeId != null && placeId.isNotEmpty) {
          queryParams['filters[feature_name][$eq]'] = placeId;
        }

        final response = await dioClient.get(
          '/api/spacemate-placeid-features',
          queryParameters: queryParams,
        );

        if (response.statusCode == 200) {
          developer.log('StrapiCarouselRepositoryImpl: Successfully fetched carousel items');
          final carouselResponse = StrapiCarouselResponse.fromJson(response.data);
          return Right(carouselResponse.data.map((item) => item.toEntity()).toList());
        } else {
          developer.log('StrapiCarouselRepositoryImpl: Failed to fetch carousel items. Status: ${response.statusCode}');
          return Left(ServerFailure('Failed to load carousel items'));
        }
      } else {
        developer.log('StrapiCarouselRepositoryImpl: No internet connection');
        return Left(NetworkFailure('No internet connection'));
      }
    } on ServerException catch (e) {
      developer.log('StrapiCarouselRepositoryImpl: Server exception: ${e.message}');
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      developer.log('StrapiCarouselRepositoryImpl: Network exception: ${e.message}');
      return Left(NetworkFailure(e.message));
    } catch (e) {
      developer.log('StrapiCarouselRepositoryImpl: Unexpected error: $e');
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CarouselItemEntity>> getCarouselItemById(String id) async {
    try {
      developer.log('StrapiCarouselRepositoryImpl: Fetching carousel item by id: $id');
      
      if (await networkInfo.isConnected) {
        final response = await dioClient.get('/api/screens/$id');

        if (response.statusCode == 200) {
          developer.log('StrapiCarouselRepositoryImpl: Successfully fetched carousel item');
          final carouselResponse = StrapiCarouselResponse.fromJson(response.data);
          if (carouselResponse.data.isNotEmpty) {
            return Right(carouselResponse.data.first.toEntity());
          } else {
            return Left(NotFoundFailure('Carousel item not found'));
          }
        } else {
          developer.log('StrapiCarouselRepositoryImpl: Failed to fetch carousel item. Status: ${response.statusCode}');
          return Left(ServerFailure('Failed to load carousel item'));
        }
      } else {
        developer.log('StrapiCarouselRepositoryImpl: No internet connection');
        return Left(NetworkFailure('No internet connection'));
      }
    } on ServerException catch (e) {
      developer.log('StrapiCarouselRepositoryImpl: Server exception: ${e.message}');
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      developer.log('StrapiCarouselRepositoryImpl: Network exception: ${e.message}');
      return Left(NetworkFailure(e.message));
    } catch (e) {
      developer.log('StrapiCarouselRepositoryImpl: Unexpected error: $e');
      return Left(UnknownFailure(e.toString()));
    }
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
    
    // Otherwise, construct the full URL using config
    final baseUrl = AppConfig.carouselStrapiBaseUrl;
    return url.startsWith('/') ? '$baseUrl$url' : '$baseUrl/$url';
  }
}
