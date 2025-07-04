import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:spacemate/core/error/failures.dart';
import 'package:spacemate/core/network/dio_client.dart';
import 'package:spacemate/features/menu/data/models/screen_api_response.dart';
import 'package:spacemate/features/menu/data/models/screen_model.dart';
import 'dart:developer' as developer;
import 'menu_remote_data_source.dart';
import 'package:spacemate/core/utils/strapi_url_builder.dart';

class MenuRemoteDataSourceImpl implements MenuRemoteDataSource {
  final DioClient dioClient;

  MenuRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Either<Failure, List<ScreenModel>>> getMenuItems({String? placeId}) async {
    try {
      // Build the Strapi URL using the new utility
      final url = StrapiUrlBuilder.build(
        resource: 'screens',
        filters: placeId != null && placeId.isNotEmpty
            ? {'slug': {'\$eq': placeId}}
            : null,
        populate: ['*'],
      );
      developer.log('MenuRemoteDataSourceImpl: Built URL: $url');

      final response = await dioClient.get(
        url,
      );
      
      developer.log('MenuRemoteDataSourceImpl: API response status: ${response.statusCode}');
      
      if (response.data == null) {
        return const Left(ServerFailure('No data received from server'));
      }
      
      final screenResponse = ScreenApiResponse.fromJson(response.data);
      developer.log('MenuRemoteDataSourceImpl: Parsed ${screenResponse.data.length} screens');
      
      // If we're filtering by slug, we should only get one screen
      // If we got multiple screens, filter them manually
      if (placeId != null && placeId.isNotEmpty && screenResponse.data.length > 1) {
        developer.log('MenuRemoteDataSourceImpl: API returned multiple screens, filtering manually');
        final filteredScreens = screenResponse.data.where((screen) => screen.slug == placeId).toList();
        developer.log('MenuRemoteDataSourceImpl: After manual filtering: ${filteredScreens.length} screens');
        return Right(filteredScreens);
      }
      
      return Right(screenResponse.data);
    } on DioException catch (e) {
      developer.log('MenuRemoteDataSourceImpl: DioException: ${e.message}');
      return Left(ServerFailure(e.message ?? 'Failed to load menu items from server.'));
    } catch (e) {
      developer.log('MenuRemoteDataSourceImpl: Unexpected error: $e');
      return Left(ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }
}

