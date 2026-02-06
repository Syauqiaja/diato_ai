part of 'course_list_cubit.dart';

sealed class CourseListState extends Equatable {
  const CourseListState();

  @override
  List<Object> get props => [];
}

final class CourseListInitial extends CourseListState {}

final class CourseListLoading extends CourseListState {}

final class CourseListLoaded extends CourseListState {
  final List<CourseItem> courses;

  const CourseListLoaded(this.courses);

  @override
  List<Object> get props => [courses];
}

final class CourseListError extends CourseListState {
  final String message;

  const CourseListError(this.message);

  @override
  List<Object> get props => [message];
}
