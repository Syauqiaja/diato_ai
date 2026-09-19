/// Which list a piece of content belongs to. Courses, guides and families are
/// served by one endpoint and told apart by this.
enum ContentType {
  course('course', 'Course'),
  guide('guide', 'Panduan'),
  family('family', 'Famili');

  /// The value the api uses in `type`.
  final String apiValue;

  /// Short name shown on search results and detail screens.
  final String label;

  const ContentType(this.apiValue, this.label);

  static ContentType fromApi(String? value) =>
      ContentType.values.firstWhere((t) => t.apiValue == value, orElse: () => ContentType.course);
}
