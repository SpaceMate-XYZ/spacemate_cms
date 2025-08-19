import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:spacemate/core/network/dio_client.dart';
import 'package:spacemate/core/error/exceptions.dart' as ex;

class ThrowingInterceptor extends Interceptor {
  final DioException toThrow;
  ThrowingInterceptor(this.toThrow);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    throw toThrow;
  }
}

void main() {
  group('DioClient _handleDioError mappings', () {
    test('maps connection timeout to TimeoutException', () async {
      final dioEx = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.connectionTimeout,
        message: 'connection timed out',
      );

      final client = DioClient(
        baseUrl: 'https://example.com',
        interceptors: [ThrowingInterceptor(dioEx)],
      );

      await client.init();

      expect(() async => await client.get('/'), throwsA(isA<ex.TimeoutException>()));
    });

    test('maps 404 badResponse to NotFoundException', () async {
      final resp = Response(
        requestOptions: RequestOptions(path: '/'),
        statusCode: 404,
        statusMessage: 'Not Found',
      );

      final dioEx = DioException(
        requestOptions: resp.requestOptions,
        type: DioExceptionType.badResponse,
        response: resp,
      );

      final client = DioClient(
        baseUrl: 'https://example.com',
        interceptors: [ThrowingInterceptor(dioEx)],
      );

      await client.init();

      expect(() async => await client.get('/'), throwsA(isA<ex.NotFoundException>()));
    });

    test('maps unknown SocketException text to NetworkException', () async {
      final dioEx = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.unknown,
        error: Exception('SocketException: Failed host lookup'),
      );

      final client = DioClient(
        baseUrl: 'https://example.com',
        interceptors: [ThrowingInterceptor(dioEx)],
      );

      await client.init();

      expect(() async => await client.get('/'), throwsA(isA<ex.NetworkException>()));
    });

    test('maps unknown non-socket error to UnknownException', () async {
      final dioEx = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.unknown,
        error: Exception('some other error'),
        message: 'boom',
      );

      final client = DioClient(
        baseUrl: 'https://example.com',
        interceptors: [ThrowingInterceptor(dioEx)],
      );

      await client.init();

      expect(() async => await client.get('/'), throwsA(isA<ex.UnknownException>()));
    });
  });
}
