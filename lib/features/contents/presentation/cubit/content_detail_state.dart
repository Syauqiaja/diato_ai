part of 'content_detail_cubit.dart';

sealed class ContentDetailState extends Equatable {
  const ContentDetailState();

  @override
  List<Object> get props => [];
}

final class ContentDetailInitial extends ContentDetailState {}

final class ContentDetailLoading extends ContentDetailState {}

final class ContentDetailData extends ContentDetailState {
  final ContentDetail contentDetail;
  const ContentDetailData(this.contentDetail);

  @override
  List<Object> get props => [contentDetail];
}

final class ContentDetailError extends ContentDetailState {
  final String message;
  const ContentDetailError(this.message);

  @override
  List<Object> get props => [message];
}
