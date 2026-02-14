part of 'explore_index_cubit.dart';

sealed class ExploreIndexState extends Equatable {
  const ExploreIndexState();

  @override
  List<Object> get props => [];
}

final class ExploreIndexEmpty extends ExploreIndexState {}
final class ExploreIndexData extends ExploreIndexState {
  final List<CourseItem> courses;
  const ExploreIndexData(this.courses);

  @override
  List<Object> get props => [courses];
}
final class ExploreIndexError extends ExploreIndexState {
  final String message;
  const ExploreIndexError(this.message);

  @override
  List<Object> get props => [message];
}
final class ExploreIndexLoading extends ExploreIndexState {}
