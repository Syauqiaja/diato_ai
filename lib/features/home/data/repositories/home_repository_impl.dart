import 'package:diato_ai/core/data/result.dart';
import 'package:diato_ai/features/home/domain/repository/home_repository.dart';
import 'package:diato_ai/features/shared/models/article.dart';
import 'package:dio/dio.dart';

final class HomeRepositoryImpl extends HomeRepository {
  final Dio dio;

  HomeRepositoryImpl(this.dio);
  @override
  Future<Result<List<Article>>> getArticles() async {
    try {
      final response = await dio.get('/articles');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] as List<dynamic>;
        final articles = data.map((json) => Article.fromJson(json as Map<String, dynamic>)).toList();
        return Result.success(articles);
      } else {
        return Result.failure(response.data['message'] ?? 'Failed to fetch articles');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final message = e.response?.data['message'];
        return Result.failure(message ?? 'An error occurred');
      } else {
        return Result.failure('Network error: ${e.message}');
      }
    } catch (e) {
      return Result.failure('Unexpected error: $e');
    }
  }
}