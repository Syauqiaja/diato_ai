import 'package:diato_ai/core/assets/constants.dart';
import 'package:equatable/equatable.dart';

import 'content_type.dart';

/// A course, guide or family as a list sends it, without its body.
final class ContentItem extends Equatable {
  final int id;
  final ContentType type;
  final String title;

  /// Guides and families may have no cover; screens fall back to the bundled
  /// picture.
  final String? cover;

  const ContentItem({required this.id, required this.type, required this.title, this.cover});

  factory ContentItem.fromJson(Map<String, dynamic> json) {
    return ContentItem(
      id: json['id'] as int,
      type: ContentType.fromApi(json['type'] as String?),
      title: json['title'] as String,
      cover: resolveAssetUrl(json['cover'] as String?),
    );
  }

  @override
  List<Object?> get props => [id, type, title, cover];
}
