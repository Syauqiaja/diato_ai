import 'package:diato_ai/core/assets/constants.dart';
import 'package:equatable/equatable.dart';

import 'content_type.dart';

/// One course, guide or family with its rich text.
final class ContentDetail extends Equatable {
  final int id;
  final ContentType type;
  final String title;
  final String? cover;

  /// HTML written in the console.
  final String content;

  const ContentDetail({
    required this.id,
    required this.type,
    required this.title,
    this.cover,
    required this.content,
  });

  factory ContentDetail.fromJson(Map<String, dynamic> json) {
    return ContentDetail(
      id: json['id'] as int,
      type: ContentType.fromApi(json['type'] as String?),
      title: json['title'] as String,
      cover: resolveAssetUrl(json['cover'] as String?),
      content: json['content'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [id, type, title, cover, content];
}
