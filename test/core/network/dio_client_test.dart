import 'package:flutter_test/flutter_test.dart';
import 'package:spacemate/core/network/dio_client.dart';
import 'package:spacemate/core/network/interceptors/auth_interceptor.dart';

void main() {
  test('init throws when baseUrl is null', () async {
    final client = DioClient(baseUrl: null, authToken: null);
    expect(() async => await client.init(), throwsA(isA<Exception>()));
  });

  test('init configures Dio with baseUrl and adds interceptors', () async {
    final client = DioClient(baseUrl: 'https://example.com', authToken: 'secret-token');
    await client.init();
    expect(client.dio.options.baseUrl, equals('https://example.com'));
    final hasAuth = client.dio.interceptors.any((i) => i is AuthInterceptor);
    expect(hasAuth, isTrue);
  });
}
