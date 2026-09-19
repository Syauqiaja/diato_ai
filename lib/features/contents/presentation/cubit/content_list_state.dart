part of 'content_list_cubit.dart';

enum ContentListStatus { initial, loading, loaded, error }

final class ContentSection extends Equatable {
  final ContentListStatus status;
  final List<ContentItem> items;
  final String? error;

  const ContentSection({
    this.status = ContentListStatus.initial,
    this.items = const [],
    this.error,
  });

  bool get isLoading => status == ContentListStatus.initial || status == ContentListStatus.loading;

  @override
  List<Object?> get props => [status, items, error];
}

final class ContentListState extends Equatable {
  final Map<ContentType, ContentSection> sections;

  const ContentListState({this.sections = const {}});

  ContentSection of(ContentType type) => sections[type] ?? const ContentSection();

  ContentListState withSection(ContentType type, ContentSection section) =>
      ContentListState(sections: {...sections, type: section});

  @override
  List<Object?> get props => [sections];
}
