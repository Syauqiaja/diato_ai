final class FoundSpecies {
  final int id;
  final int? speciesId;
  final String name;

  /// Sampling year this record belongs to; null for records made before
  /// stations were split by year.
  final int? year;
  final int count;

  FoundSpecies({
    required this.id,
    required this.speciesId,
    required this.name,
    required this.year,
    required this.count,
  });

  factory FoundSpecies.fromJson(Map<String, dynamic> json) {
    return FoundSpecies(
      id: json['id'] as int,
      speciesId: (json['species_id'] as num?)?.toInt(),
      name: json['name'] as String? ?? '',
      year: (json['year'] as num?)?.toInt(),
      count: (json['count'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'species_id': speciesId,
      'name': name,
      'year': year,
      'count': count,
    };
  }
}

/// One species at a station, merged across the years it was recorded in.
final class StationSpeciesSummary {
  final String name;

  /// Years the species was found, oldest first. Excludes undated records.
  final List<int> years;
  final int count;

  const StationSpeciesSummary({required this.name, required this.years, required this.count});
}
