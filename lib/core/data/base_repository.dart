import 'package:dio/dio.dart';
import 'package:diato_ai/core/data/dio_client.dart';

abstract class BaseRepository {
  final String baseUrl = 'http://202.10.38.33/api';

  /// The configured Dio instance for making HTTP requests
  final Dio dio = DioClient.instance;
}
