import 'package:bloc/bloc.dart';
import 'package:diato_ai/features/courses/domain/repositories/course_repository.dart';
import 'package:diato_ai/features/shared/models/course_detail.dart';
import 'package:equatable/equatable.dart';

part 'course_detail_state.dart';

class CourseDetailCubit extends Cubit<CourseDetailState> {
  final CourseRepository courseRepository;
  CourseDetailCubit(this.courseRepository) : super(CourseDetailInitial());

  Future<void> fetchCourseDetail(int courseId) async {
    emit(CourseDetailLoading());
    final result = await courseRepository.getCourseDetail(courseId);

    result.when(
      success: (courseDetail) => emit(CourseDetailData(courseDetail)),
      failure: (error) => emit(CourseDetailError(error)),
    );
  }
}
