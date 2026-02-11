import 'package:diato_ai/core/data/result.dart';
import 'package:diato_ai/features/shared/models/course_detail.dart';
import 'package:diato_ai/features/shared/models/course_item.dart';

abstract class CourseRepository {
  Future<Result<List<CourseItem>>> getCourses({String? query});
  Future<Result<CourseDetail>> getCourseDetail(String courseId);
}