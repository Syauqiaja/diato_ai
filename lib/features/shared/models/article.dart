final class Article {
  final int id;
  final String title;
  final String cover;
  final String url;
  final String overview;

  Article({required this.id, required this.title, required this.cover, required this.url, this.overview = ''});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(id: json['id'] as int, title: json['title'] as String, cover: json['cover'] as String, url: json['url'] as String, overview: json['overview'] as String? ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'cover': cover, 'url': url, 'overview': overview};
  }
}
