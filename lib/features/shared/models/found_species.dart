final class FoundSpecies {
  final int id;
  final String name;
  final int count;

  FoundSpecies({required this.id, required this.name, required this.count});

  factory FoundSpecies.fromJson(Map<String, dynamic> json) {
    return FoundSpecies(
      id: json['id'] as int,
      name: json['name'] as String,
      count: (json['count'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'count': count,
    };
  }
}
