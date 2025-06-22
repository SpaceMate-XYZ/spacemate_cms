import 'package:dio/dio.dart';
import 'package:spacemate/core/error/exceptions.dart';
import 'package:spacemate/core/network/dio_client.dart';
import 'package:spacemate/features/menu/data/models/menu_item_model.dart';
import 'menu_remote_data_source.dart';

class MenuRemoteDataSourceImpl implements MenuRemoteDataSource {
  final DioClient _dioClient;

  MenuRemoteDataSourceImpl({required DioClient dioClient}) : _dioClient = dioClient;

  @override
  Future<List<MenuItemModel>> getMenuItems({
    required String placeId,
    required String category,
    String? locale,
    CancelToken? cancelToken,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'filters[category][\$eq]': category,
        'sort': 'order:asc',
        'populate': '*',
      };

      if (locale != null) {
        queryParams['locale'] = locale;
      }

      final response = await _dioClient.get(
        '/api/$placeId-menu-screens',
        queryParameters: queryParams,
        cancelToken: cancelToken,
      );

      if (response.data == null || response.data['data'] == null) {
        throw ServerException('Invalid response format');
      }

      final List<dynamic> data = response.data['data'];
      return data
          .map((item) => MenuItemModel.fromJson({
                'id': item['id'],
                ...item['attributes'],
              }))
          .toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to load menu items');
    } catch (e) {
      throw ServerException('Failed to load menu items: ${e.toString()}');
    }
  }

  @override
  Future<List<String>> getSupportedLocales({
    required String placeId,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dioClient.get(
        '/i18n/locales',
        cancelToken: cancelToken,
      );

      if (response.data == null || !(response.data is List)) {
        throw ServerException('Invalid locales format');
      }

      return (response.data as List).map((e) => e['code'] as String).toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to load supported locales');
    } catch (e) {
      throw ServerException('Failed to load supported locales: ${e.toString()}');
    }
  }
}
