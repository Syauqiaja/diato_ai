import 'package:dio/dio.dart';
import 'package:diato_ai/core/device/device_installation_id.dart';
import 'package:diato_ai/features/auth/core/auth_core.dart';
import 'package:get_it/get_it.dart';

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
        baseUrl: 'https://diato-ai.fajrsyauqi.com/api',
        connectTimeout: const Duration(seconds: 30),
        // Uploading a photo and waiting on CNN inference takes longer than a
        // plain JSON read, so allow more headroom than the default.
        receiveTimeout: const Duration(seconds: 60),
        sendTimeout: const Duration(seconds: 60),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Attach the stored bearer token to every request.
    //
    // Without this the token saved at login is never sent, so any endpoint
    // behind `auth:sanctum` — including POST /scans — answers 401.
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Resolved lazily: AuthCore is registered after Dio in the DI setup.
          if (GetIt.instance.isRegistered<AuthCore>()) {
            final token = await GetIt.instance<AuthCore>().getToken();
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }

          // Identify the installation for endpoints that belong to a device
          // rather than an account — saved calculator readings are kept per
          // device because the calculator never asks anyone to sign in.
          if (GetIt.instance.isRegistered<DeviceInstallationId>()) {
            options.headers['X-Device-Id'] =
                await GetIt.instance<DeviceInstallationId>().get();
          }

          return handler.next(options);
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
