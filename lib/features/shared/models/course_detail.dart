import 'package:diato_ai/core/assets/constants.dart';

final class CourseDetail {
  final int id;
  final String title;
  final String cover;
  final String content;

  CourseDetail({required this.id, required this.title, required this.cover, required this.content});

  factory CourseDetail.fromJson(Map<String, dynamic> json) {
    return CourseDetail(
      id: json['id'] as int,
      title: json['title'] as String,
      cover: resolveAssetUrl(json['cover'] as String?) ?? '',
      content: json['content'] as String,
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