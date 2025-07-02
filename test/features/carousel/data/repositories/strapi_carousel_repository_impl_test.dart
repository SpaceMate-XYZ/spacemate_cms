import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spacemate/features/carousel/data/repositories/strapi_carousel_repository_impl.dart';
import 'package:spacemate/core/network/dio_client.dart';
import 'package:spacemate/core/network/network_info.dart';
import 'package:spacemate/features/carousel/data/models/strapi_carousel_model.dart';
import 'package:dartz/dartz.dart';
import 'package:spacemate/core/error/failures.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MockDioClient extends Mock implements DioClient {}
class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  setUpAll(() async {
    await dotenv.load();
  });

  late MockDioClient mockDioClient;
  late MockNetworkInfo mockNetworkInfo;
  late StrapiCarouselRepositoryImpl repo;

  setUp(() {
    mockDioClient = MockDioClient();
    mockNetworkInfo = MockNetworkInfo();
    when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    repo = StrapiCarouselRepositoryImpl(
      dioClient: mockDioClient,
      networkInfo: mockNetworkInfo,
    );
  });

  group('StrapiCarouselRepositoryImpl', () {
    test('builds correct URL with placeId', () async {
      when(() => mockDioClient.get(any())).thenAnswer((_) async =>
        Response(data: {'data': []}, statusCode: 200, requestOptions: RequestOptions(path: '')));
      await repo.getCarouselItems(placeId: 'parking');
      verify(() => mockDioClient.get('/api/spacemate-placeid-features?filters%5Bfeature_name%5D%5B%24eq%5D=parking&populate=%2A')).called(1);
    });

    test('builds correct URL without placeId', () async {
      when(() => mockDioClient.get(any())).thenAnswer((_) async =>
        Response(data: {'data': []}, statusCode: 200, requestOptions: RequestOptions(path: '')));
      await repo.getCarouselItems();
      verify(() => mockDioClient.get('/api/spacemate-placeid-features?populate=%2A')).called(1);
    });

    test('builds correct URL for getCarouselItemById', () async {
      when(() => mockDioClient.get(any())).thenAnswer((_) async =>
        Response(data: {'data': []}, statusCode: 200, requestOptions: RequestOptions(path: '')));
      await repo.getCarouselItemById('123');
      verify(() => mockDioClient.get('/api/screens/123')).called(1);
    });

    test('builds correct URL for getCarouselItemById with 404', () async {
      when(() => mockDioClient.get(any())).thenAnswer((_) async =>
        Response(data: null, statusCode: 404, requestOptions: RequestOptions(path: '')));
      await repo.getCarouselItemById('123');
      verify(() => mockDioClient.get('/api/screens/123')).called(1);
    });

    test('builds correct URL for getCarouselItemById with null', () async {
      when(() => mockDioClient.get(any())).thenAnswer((_) async =>
        Response(data: null, statusCode: 200, requestOptions: RequestOptions(path: '')));
      await repo.getCarouselItemById('123');
      verify(() => mockDioClient.get('/api/screens/123')).called(1);
    });
  });
}