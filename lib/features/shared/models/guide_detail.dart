import 'package:diato_ai/core/assets/constants.dart';

final class GuideDetail {
  final int id;
  final String title;
  final String? cover;
  final String content;

  GuideDetail({required this.id, required this.title, this.cover, required this.content});

  factory GuideDetail.fromJson(Map<String, dynamic> json) {
    return GuideDetail(
      id: json['id'] as int,
      title: json['title'] as String,
      cover: resolveAssetUrl(json['cover'] as String?),
      content: json['content'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'cover': cover,
      'content': content,
    };
  }
}
