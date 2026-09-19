import 'package:diato_ai/core/data/result.dart';
import 'package:dio/dio.dart';

import '../../domain/repositories/content_repository.dart';
import '../models/content_detail.dart';
import '../models/content_item.dart';
import '../models/content_search_result.dart';
import '../models/content_type.dart';

final class ContentRepositoryImpl extends ContentRepository {
  final Dio dio;

  ContentRepositoryImpl(this.dio);

  @override
  Future<Result<List<ContentItem>>> getContents(ContentType type) {
    return _get(
      '/contents',
      query: {'type': type.apiValue},
      fallback: 'Gagal memuat daftar ${type.label.toLowerCase()}',
      parse: (data) => (data as List<dynamic>)
          .map((json) => ContentItem.fromJson(json as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<Result<ContentDetail>> getContentDetail(int contentId) {
    return _get(
      '/contents/$contentId',
      fallback: 'Gagal memuat materi',
      parse: (data) => ContentDetail.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<Result<List<ContentSearchResult>>> search(String query) {
    return _get(
      '/contents/search',
      query: {'q': query},
      fallback: 'Gagal mencari',
      parse: (data) => (data as List<dynamic>)
          .map((json) => ContentSearchResult.fromJson(json as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<Result<T>> _get<T>(
    String path, {
    Map<String, dynamic>? query,
    required String fallback,
    required T Function(dynamic data) parse,
  }) async {
    try {
      final response = await dio.get(path, queryParameters: query);

      if (response.statusCode == 200) {
        return Result.success(parse(response.data['data']));
      }
      return Result.failure(response.data['message'] ?? fallback);
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map && data['message'] is String) {
        return Result.failure(data['message'] as String);
      }
      if (e.response != null) return Result.failure(fallback);
      return Result.failure('Network error: ${e.message}');
    } catch (e) {
      return Result.failure('Unexpected error: $e');
    }
  }
}
