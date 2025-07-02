import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spacemate/core/error/exceptions.dart';
import 'package:spacemate/core/error/failures.dart';
import 'package:spacemate/core/network/dio_client.dart';
import 'package:spacemate/features/menu/data/datasources/menu_remote_data_source_impl.dart';
import 'package:spacemate/features/menu/data/models/screen_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockDioClient extends Mock implements DioClient {}

void main() {
  late MenuRemoteDataSourceImpl dataSource;
  late MockDioClient mockDioClient;

  setUp(() {
    mockDioClient = MockDioClient();
    dataSource = MenuRemoteDataSourceImpl(dioClient: mockDioClient);
  });

  group('getMenuItems', () {

    test(
      'should return List<ScreenModel> when the response code is 200 (success)',
      () async {
        // Arrange
        when(() => mockDioClient.get(any())).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/api/screens'),
            data: json.decode(fixture('screens_response.json')),
            statusCode: 200,
          ),
        );

        // Act
        final result = await dataSource.getMenuItems(placeId: 'home');
        final items = result.getOrElse(() => []);

        // Assert
        expect(items.length, equals(1));
        expect(items[0].id, equals(1));
        expect(items[0].slug, equals('home'));
      },
    );

    test(
      'should return ServerFailure when the response code is 404 or other error',
      () async {
        // Arrange
        when(() => mockDioClient.get(any())).thenThrow(
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
        final result = await dataSource.getMenuItems(placeId: 'home');

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) => expect(failure, isA<ServerFailure>()),
          (success) => fail('Expected failure but got success'),
        );
      },
    );

    test(
      'should return ServerFailure when no data is received',
      () async {
        // Arrange
        when(() => mockDioClient.get(any())).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/api/screens'),
            data: null,
            statusCode: 200,
          ),
        );

        // Act
        final result = await dataSource.getMenuItems(placeId: 'home');

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) => expect(failure, isA<ServerFailure>()),
          (success) => fail('Expected failure but got success'),
        );
      },
    );
  });
}
