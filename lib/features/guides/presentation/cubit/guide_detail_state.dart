part of 'guide_detail_cubit.dart';

sealed class GuideDetailState extends Equatable {
  const GuideDetailState();

  @override
  List<Object> get props => [];
}

final class GuideDetailInitial extends GuideDetailState {}

final class GuideDetailLoading extends GuideDetailState {}

final class GuideDetailData extends GuideDetailState {
  final GuideDetail guideDetail;
  const GuideDetailData(this.guideDetail);

  @override
  List<Object> get props => [guideDetail];
}

final class GuideDetailError extends GuideDetailState {
  final String message;
  const GuideDetailError(this.message);

  @override
  List<Object> get props => [message];
}
