import 'package:dio/dio.dart';
import 'package:spacemate/core/error/exceptions.dart';
import 'package:spacemate/core/network/dio_client.dart';
import 'package:spacemate/features/menu/data/models/screen_api_response.dart';
import 'package:spacemate/features/menu/data/models/screen_model.dart';
import 'menu_remote_data_source.dart';

class MenuRemoteDataSourceImpl implements MenuRemoteDataSource {
  final DioClient dioClient;

  MenuRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<ScreenModel>> getMenuItems({required String slug, String? locale}) async {
    try {
      final response = await dioClient.get(
        '/api/screens',
        queryParameters: {
          'filters[slug][\$eq]': slug,
          'populate': 'MenuGrid',
        },
      );
      
      if (response.data == null) {
        throw ServerException('No data received from server');
      }
      
      final screenResponse = ScreenApiResponse.fromJson(response.data);
      return screenResponse.data;
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to load menu items from server.');
    } catch (e) {
      throw ServerException('An unexpected error occurred: ${e.toString()}');
    }
  }
}

