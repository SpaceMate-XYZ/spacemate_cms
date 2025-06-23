import 'package:dio/dio.dart';
import 'package:spacemate/core/error/exceptions.dart';
import 'package:spacemate/core/network/dio_client.dart';
import 'package:spacemate/features/menu/data/models/menu_item_model.dart';
import 'package:spacemate/features/menu/data/models/screen_api_response.dart';
import 'menu_remote_data_source.dart';

class MenuRemoteDataSourceImpl implements MenuRemoteDataSource {
  final DioClient _dioClient;

  MenuRemoteDataSourceImpl({required DioClient dioClient}) : _dioClient = dioClient;

  @override
  Future<List<MenuItemModel>> getMenuItems({
    required String slug,
    String? locale,
    CancelToken? cancelToken,
  }) async {
    try {
      final Map<String, dynamic> queryParameters = {
        'filters[slug[]\$eq]': slug,
        'populate': 'MenuGrid',
      };

      if (locale != null) {
        queryParameters['locale'] = locale;
      }

      final response = await _dioClient.get(
        '/api/screens',
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );

      final apiResponse = ScreenApiResponse.fromJson(response.data);

      if (apiResponse.data.isEmpty) {
        return [];
      }

      return apiResponse.data.first.menuGrid;
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to load menu items from server.');
    } catch (e) {
      throw ServerException('An unexpected error occurred: ${e.toString()}');
    }
  }
}

