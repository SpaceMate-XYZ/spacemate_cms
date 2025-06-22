import 'package:dio/dio.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('\n--- Request ---');
    print('${options.method} ${options.uri}');
    if (options.queryParameters.isNotEmpty) {
      print('Query Parameters: ${options.queryParameters}');
    }
    if (options.data != null) {
      print('Request Data: ${options.data}');
    }
    if (options.headers.isNotEmpty) {
      print('Headers: ${options.headers}');
    }
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('\n--- Response ---');
    print('${response.statusCode} ${response.statusMessage}');
    print('${response.requestOptions.method} ${response.requestOptions.path}');
    print('Data: ${response.data}');
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('\n--- Error ---');
    print('${err.requestOptions.method} ${err.requestOptions.path}');
    print('Error: ${err.error}');
    print('Response: ${err.response?.statusCode} - ${err.response?.statusMessage}');
    print('Data: ${err.response?.data}');
    return super.onError(err, handler);
  }
}
