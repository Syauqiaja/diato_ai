part of 'course_detail_cubit.dart';

sealed class CourseDetailState extends Equatable {
  const CourseDetailState();

  @override
  List<Object> get props => [];
}

final class CourseDetailInitial extends CourseDetailState {}
final class CourseDetailData extends CourseDetailState {
  final CourseDetail courseDetail;
  const CourseDetailData(this.courseDetail);

  @override
  List<Object> get props => [courseDetail];
}
final class CourseDetailError extends CourseDetailState {
  final String message;
  const CourseDetailError(this.message);

  @override
  List<Object> get props => [message];
}

final class CourseDetailLoading extends CourseDetailState {}