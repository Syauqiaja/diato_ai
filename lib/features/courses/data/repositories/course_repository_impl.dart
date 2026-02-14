import 'package:diato_ai/core/data/result.dart';
import 'package:diato_ai/features/courses/domain/repositories/course_repository.dart';
import 'package:diato_ai/features/shared/models/course_detail.dart';
import 'package:diato_ai/features/shared/models/course_item.dart';
import 'package:dio/dio.dart';

final class CourseRepositoryImpl extends CourseRepository {
  final Dio dio;

  CourseRepositoryImpl(this.dio);

  @override
  Future<Result<List<CourseItem>>> getCourses({String? query}) async {
    try {
      final response = await dio.get('/courses', queryParameters: query != null ? {'q': query} : null);

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

  @override
  Future<Result<CourseDetail>> getCourseDetail(int courseId) async {
    try {
      final response = await dio.get('/courses/$courseId');

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
}