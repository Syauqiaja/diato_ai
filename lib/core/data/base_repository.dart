import 'package:dio/dio.dart';

abstract class BaseRepository {
  final String baseUrl = 'http://202.10.38.33/api';

  /// The configured Dio instance for making HTTP requests
  final Dio dio;

  BaseRepository({required this.dio});
}
