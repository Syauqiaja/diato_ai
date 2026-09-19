import 'package:diato_ai/core/assets/constants.dart';
import 'package:equatable/equatable.dart';

import 'content_type.dart';

/// One hit from /contents/search. The server ranks title hits above content
/// hits and sends the line of text the query was found on.
final class ContentSearchResult extends Equatable {
  final int id;
  final ContentType type;
  final String title;
  final String? cover;

  /// True when the query is in the title, false when only in the body.
  final bool matchedInTitle;

  /// The line of the body holding the query; for a title hit with no body
  /// match, the opening line. Null when the body is empty.
  final String? snippet;

  const ContentSearchResult({
    required this.id,
    required this.type,
    required this.title,
    this.cover,
    required this.matchedInTitle,
    this.snippet,
  });

  factory ContentSearchResult.fromJson(Map<String, dynamic> json) {
    return ContentSearchResult(
      id: json['id'] as int,
      type: ContentType.fromApi(json['type'] as String?),
      title: json['title'] as String,
      cover: resolveAssetUrl(json['cover'] as String?),
      matchedInTitle: json['matched_in'] == 'title',
      snippet: json['snippet'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, type, title, cover, matchedInTitle, snippet];
}
