import 'package:diato_ai/core/data/base_repository.dart';
import 'package:diato_ai/core/data/result.dart';
import 'package:diato_ai/features/shared/models/article.dart';
import 'package:diato_ai/features/shared/models/course_item.dart';
import 'package:dio/dio.dart';

import '../../shared/models/course_detail.dart';

final class HomeRepository extends BaseRepository {
  Future<Result<List<CourseItem>>> getCourses({String? query}) async {
    try {
      final response = await dio.get('$baseUrl/courses', queryParameters: query != null ? {'q': query} : null);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] as List<dynamic>;
        final courses = data.map((json) => CourseItem.fromJson(json as Map<String, dynamic>)).toList();
        return Result.success(courses);
      } else {
        return Result.failure(response.data['message'] ?? 'Failed to fetch courses');
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

  Future<Result<CourseDetail>> getCourseDetail(String courseId) async {
    try {
      final response = await dio.get('$baseUrl/courses/$courseId');

      if (response.statusCode == 200) {
        final courseDetail = CourseDetail.fromJson(response.data['data'] as Map<String, dynamic>);
        return Result.success(courseDetail);
      } else {
        return Result.failure(response.data['message'] ?? 'Failed to fetch course detail');
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

  Future<Result<List<Article>>> getArticles() async {
    try {
      final response = await dio.get('$baseUrl/articles');

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