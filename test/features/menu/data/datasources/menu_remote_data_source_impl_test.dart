import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spacemate/features/menu/data/datasources/menu_remote_data_source_impl.dart';
import 'package:spacemate/core/network/dio_client.dart';
import 'package:dio/dio.dart';

class MockDioClient extends Mock implements DioClient {}

void main() {
  group('MenuRemoteDataSourceImpl', () {
    late MockDioClient mockDioClient;
    late MenuRemoteDataSourceImpl dataSource;

    setUp(() {
      mockDioClient = MockDioClient();
      dataSource = MenuRemoteDataSourceImpl(dioClient: mockDioClient);
    });

    test('builds correct URL with slug', () async {
      when(() => mockDioClient.get(any())).thenAnswer((_) async =>
        Response(data: {'data': []}, statusCode: 200, requestOptions: RequestOptions(path: '')));
      await dataSource.getMenuItems(placeId: 'home');
      verify(() => mockDioClient.get('/api/screens?filters%5Bslug%5D%5B%24eq%5D=home&populate=%2A')).called(1);
    });

    test('builds correct URL without slug', () async {
      when(() => mockDioClient.get(any())).thenAnswer((_) async =>
        Response(data: {'data': []}, statusCode: 200, requestOptions: RequestOptions(path: '')));
      await dataSource.getMenuItems();
      verify(() => mockDioClient.get('/api/screens?populate=%2A')).called(1);
    });
  });
} 