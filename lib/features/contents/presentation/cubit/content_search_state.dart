part of 'content_search_cubit.dart';

sealed class ContentSearchState extends Equatable {
  const ContentSearchState();

  @override
  List<Object> get props => [];
}

/// Nothing typed: the explore page shows its lists.
final class ContentSearchIdle extends ContentSearchState {}

final class ContentSearchLoading extends ContentSearchState {
  final String query;
  const ContentSearchLoading(this.query);

  @override
  List<Object> get props => [query];
}

final class ContentSearchData extends ContentSearchState {
  final String query;
  final List<ContentSearchResult> results;
  const ContentSearchData(this.query, this.results);

  @override
  List<Object> get props => [query, results];
}

final class ContentSearchError extends ContentSearchState {
  final String query;
  final String message;
  const ContentSearchError(this.query, this.message);

  @override
  List<Object> get props => [query, message];
}
