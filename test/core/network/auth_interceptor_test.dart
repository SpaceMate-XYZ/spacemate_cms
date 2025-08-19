import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spacemate/core/network/interceptors/auth_interceptor.dart';

void main() {
  test('onRequest adds Authorization header when missing', () {
    final interceptor = AuthInterceptor(authToken: 'abc123');
    final options = RequestOptions(path: '/test');
    final handler = RequestInterceptorHandler();

    interceptor.onRequest(options, handler);

    expect(options.headers['Authorization'], equals('Bearer abc123'));
  });

  test('onRequest preserves existing Authorization header', () {
    final interceptor = AuthInterceptor(authToken: 'abc123');
    final options = RequestOptions(path: '/test', headers: {'Authorization': 'Bearer existing'});
    final handler = RequestInterceptorHandler();

    interceptor.onRequest(options, handler);

    expect(options.headers['Authorization'], equals('Bearer existing'));
  });
}
