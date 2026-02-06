import 'package:bloc/bloc.dart';
import 'package:diato_ai/core/data/result.dart';
import 'package:diato_ai/core/di/injection.dart';
import 'package:diato_ai/features/home/repository/home_repository.dart';
import 'package:diato_ai/features/shared/models/course_item.dart';
import 'package:equatable/equatable.dart';

part 'course_list_state.dart';

class CourseListCubit extends Cubit<CourseListState> {
  final HomeRepository _homeRepository;

  CourseListCubit({HomeRepository? homeRepository})
      : _homeRepository = homeRepository ?? getIt<HomeRepository>(),
        super(CourseListInitial());

  /// Fetch all courses or search courses by query
  Future<void> getCourses({String? query}) async {
    emit(CourseListLoading());

    try {
      final result = await _homeRepository.getCourses(query: query);

      switch (result) {
        case Success<List<CourseItem>>():
          emit(CourseListLoaded(result.data));
        case Failure<List<CourseItem>>():
          emit(CourseListError(result.message));
      }
    } catch (e) {
      emit(CourseListError('An unexpected error occurred: $e'));
    }
  }
}
