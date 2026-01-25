import 'package:dio/dio.dart';

/// A configured Dio client for making HTTP requests.
///
/// This class provides a singleton instance of Dio with pre-configured
/// settings including base URL, timeouts, headers, and interceptors.
class DioClient {
  static final DioClient _instance = DioClient._internal();
  late final Dio dio;

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'http://202.10.38.33/api',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        requestHeader: true,
        responseHeader: false,
        request: true,
      ),
    );

    // Add custom error handling interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException error, ErrorInterceptorHandler handler) {
          // You can add custom error handling here
          // For example: logging, showing notifications, etc.
          return handler.next(error);
        },
      ),
    );
  }

  /// Get the configured Dio instance
  static Dio get instance => _instance.dio;
}
