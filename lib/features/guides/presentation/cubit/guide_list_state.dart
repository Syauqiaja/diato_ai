part of 'guide_list_cubit.dart';

sealed class GuideListState extends Equatable {
  const GuideListState();

  @override
  List<Object> get props => [];
}

final class GuideListInitial extends GuideListState {}

final class GuideListLoading extends GuideListState {}

final class GuideListData extends GuideListState {
  final List<GuideItem> guides;
  const GuideListData(this.guides);

  @override
  List<Object> get props => [guides];
}

final class GuideListError extends GuideListState {
  final String message;
  const GuideListError(this.message);

  @override
  List<Object> get props => [message];
}
