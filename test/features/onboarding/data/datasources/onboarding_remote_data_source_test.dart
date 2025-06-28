import 'dart:convert';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:spacemate/core/error/exceptions.dart';
import 'package:spacemate/core/error/failures.dart';
import 'package:spacemate/core/network/dio_client.dart';
import 'package:spacemate/features/onboarding/data/datasources/onboarding_remote_data_source.dart';
import 'package:spacemate/features/onboarding/data/models/spacemate_placeid_features_response.dart';

// Import the fixture_reader from the correct path
import '../../../../fixtures/fixture_reader.dart';

@GenerateMocks([DioClient])
import 'onboarding_remote_data_source_test.mocks.dart';

void main() {
  late OnboardingRemoteDataSourceImpl dataSource;
  late MockDioClient mockDioClient;

  setUp(() {
    mockDioClient = MockDioClient();
    dataSource = OnboardingRemoteDataSourceImpl(dioClient: mockDioClient);
  });

  group('fetchFeaturesWithOnboarding', () {
    // Load the fixture file
    final jsonString = fixture('spacemate_placeid_features_response.json');
    final tSpacematePlaceidFeaturesResponse = SpacematePlaceidFeaturesResponse.fromJson(
        json.decode(jsonString) as Map<String, dynamic>);

    test(
      'should return SpacematePlaceidFeaturesResponse when the response code is 200',
      () async {
        // Arrange
        when(mockDioClient.get(any)).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/api/spacemate-placeid-features?populate=*'),
            statusCode: 200,
            data: json.decode(fixture('spacemate_placeid_features_response.json')) as Map<String, dynamic>,
          ),
        );
        // Act
        final result = await dataSource.fetchFeaturesWithOnboarding();
        // Assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Expected right, got left with \${failure.message}'),
          (response) => expect(response, tSpacematePlaceidFeaturesResponse),
        );
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other error',
      () async {
        // Arrange
        when(mockDioClient.get(any)).thenThrow(
          ServerException('Not Found', statusCode: 404),
        );
        // Act
        final result = await dataSource.fetchFeaturesWithOnboarding();
        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<ServerFailure>()),
          (response) => fail('Expected left, got right with \${response}'),
        );
      },
    );
  });
}