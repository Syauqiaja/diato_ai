import 'package:diato_ai/core/assets/constants.dart';

/// A guide as the list endpoint sends it, without its content.
final class GuideItem {
  final int id;
  final String title;

  /// Guides may have no cover; screens fall back to the bundled picture.
  final String? cover;

  GuideItem({required this.id, required this.title, this.cover});

  factory GuideItem.fromJson(Map<String, dynamic> json) {
    return GuideItem(
      id: json['id'] as int,
      title: json['title'] as String,
      cover: resolveAssetUrl(json['cover'] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'cover': cover,
    };
  }
}
