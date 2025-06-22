import 'dart:async';
import 'package:dio/dio.dart';
import 'package:spacemate/core/config/strapi_config.dart';
import 'package:spacemate/core/error/exceptions.dart';
import 'package:spacemate/core/network/interceptors/auth_interceptor.dart';
import 'package:spacemate/core/network/interceptors/logging_interceptor.dart';

class DioClient {
  final String? baseUrl;
  final String? authToken;
  final Duration timeout;
  final List<Interceptor> interceptors;

  Dio? _dio;

  DioClient({
    required this.baseUrl,
    this.authToken,
    this.timeout = const Duration(seconds: 30),
    List<Interceptor>? interceptors,
  }) : interceptors = [
          if (authToken != null) AuthInterceptor(authToken: authToken),
          LoggingInterceptor(),
          ...?interceptors,
        ];

  Dio get dio {
    if (_dio == null) {
      throw ServerException('Dio client is not initialized. Call init() first.');
    }
    return _dio!;
  }

  Future<void> init() async {
    if (_dio != null) return;

    if (baseUrl == null) {
      throw ServerException('Base URL is not set. Please configure Strapi URL.');
    }

    final options = BaseOptions(
      baseUrl: baseUrl!,
      connectTimeout: timeout,
      receiveTimeout: timeout,
      sendTimeout: timeout,
      responseType: ResponseType.json,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    _dio = Dio(options);

    // Add interceptors
    _dio!.interceptors.addAll(interceptors);
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  // Add other HTTP methods (post, put, delete, etc.) as needed

  void _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw TimeoutException('Connection timeout with the server');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.statusMessage ?? 'Something went wrong';
        
        switch (statusCode) {
          case 400:
            throw InvalidInputException(message);
          case 401:
            throw UnauthorizedException(message);
          case 404:
            throw NotFoundException(message);
          case 500:
          default:
            throw ServerException(message, statusCode: statusCode);
        }
      case DioExceptionType.cancel:
        throw NetworkException('Request to API server was cancelled');
      case DioExceptionType.unknown:
      default:
        if (error.error?.toString().contains('SocketException') == true) {
          throw NetworkException('No Internet connection');
        }
        throw UnknownException('Unexpected error occurred: ${error.message}');
    }
  }
}
