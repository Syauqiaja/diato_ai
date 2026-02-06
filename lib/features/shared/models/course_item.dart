final class CourseItem {
  final String id;
  final String title;
  final String cover;

  CourseItem({required this.id, required this.title, required this.cover});

  factory CourseItem.fromJson(Map<String, dynamic> json) {
    return CourseItem(
      id: json['id'] as String,
      title: json['title'] as String,
      cover: json['cover'] as String,
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