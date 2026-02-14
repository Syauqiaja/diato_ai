import 'package:bloc/bloc.dart';
import 'package:diato_ai/features/courses/domain/repositories/course_repository.dart';
import 'package:diato_ai/features/shared/models/course_item.dart';
import 'package:equatable/equatable.dart';

part 'explore_index_state.dart';

class ExploreIndexCubit extends Cubit<ExploreIndexState> {
  final CourseRepository courseRepository;
  ExploreIndexCubit(this.courseRepository) : super(ExploreIndexEmpty());

  Future<void> fetchCourses({String? query}) async {
    emit(ExploreIndexLoading());
    final result = await courseRepository.getCourses(query: query);

    result.when(
      success: (courses) => emit(ExploreIndexData(courses)),
      failure: (error) => emit(ExploreIndexError(error)),
    );
  }
}
