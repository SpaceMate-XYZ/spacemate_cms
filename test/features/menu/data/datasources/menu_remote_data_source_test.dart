import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spacemate/core/error/exceptions.dart';
import 'package:spacemate/core/network/dio_client.dart';
import 'package:spacemate/features/menu/data/datasources/menu_remote_data_source_impl.dart';
import 'package:spacemate/features/menu/data/models/screen_model.dart';

import '../../test_helpers/fixture_reader.dart';

class MockDioClient extends Mock implements DioClient {}

void main() {
  late MenuRemoteDataSourceImpl dataSource;
  late MockDioClient mockDioClient;

  setUp(() {
    mockDioClient = MockDioClient();
    dataSource = MenuRemoteDataSourceImpl(dioClient: mockDioClient);
  });

  group('getMenuItems', () {
    final tScreenModel = ScreenModel.fromJson(json.decode(fixture('screen.json'))['data'][0]);
    final tScreenList = [tScreenModel];

    test(
      'should return List<ScreenModel> when the response code is 200 (success)',
      () async {
        // Arrange
        when(() => mockDioClient.get(
              any(),
              queryParameters: any(named: 'queryParameters'),
            )).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/api/screens'),
            data: json.decode(fixture('screens_response.json')),
            statusCode: 200,
          ),
        );

        // Act
        final result = await dataSource.getMenuItems(slug: 'home');

        // Assert
        expect(result, equals(tScreenList));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other error',
      () async {
        // Arrange
        when(() => mockDioClient.get(
              any(),
              queryParameters: any(named: 'queryParameters'),
            )).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/api/screens'),
            response: Response(
              requestOptions: RequestOptions(path: '/api/screens'),
              statusCode: 404,
            ),
            type: DioExceptionType.badResponse,
            error: 'Not Found',
          ),
        );

        // Act
        final call = dataSource.getMenuItems;

        // Assert
        expect(
          () => call(slug: 'home'),
          throwsA(const TypeMatcher<ServerException>()),
        );
      },
    );

    test(
      'should throw a ServerException when no data is received',
      () async {
        // Arrange
        when(() => mockDioClient.get(
              any(),
              queryParameters: any(named: 'queryParameters'),
            )).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/api/screens'),
            data: null,
            statusCode: 200,
          ),
        );

        // Act
        final call = dataSource.getMenuItems;

        // Assert
        expect(
          () => call(slug: 'home'),
          throwsA(const TypeMatcher<ServerException>()),
        );
      },
    );
  });
}
