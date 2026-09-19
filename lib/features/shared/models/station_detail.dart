import 'package:diato_ai/core/assets/constants.dart';
import 'package:diato_ai/features/shared/models/found_species.dart';
import 'package:diato_ai/features/shared/models/station.dart';
import 'package:diato_ai/features/shared/models/station_physicochemistry.dart';

final class StationDetail {
  final int id;
  final String title;
  final String description;
  final double latitude;
  final double longitude;
  final String? image;
  final List<FoundSpecies> foundSpecies;
  final int totalSpeciesCount;
  final int totalIndividualsCount;

  /// Physicochemical readings, in the order the API listed them.
  final List<StationPhysicochemistry> physicochemistry;

  /// Sampling years this station has species records for, oldest first.
  final List<int> years;

  StationDetail({
    required this.id,
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.image,
    required this.foundSpecies,
    required this.totalSpeciesCount,
    required this.totalIndividualsCount,
    required this.physicochemistry,
    required this.years,
  });

  /// Absolute url for [image]. See [Station.imageUrl].
  String? get imageUrl => resolveAssetUrl(image);

  /// Species found in [year], or across every year when [year] is null, one
  /// entry per species in the order the API listed them.
  List<StationSpeciesSummary> speciesFor(int? year) {
    final records = <Object, List<FoundSpecies>>{};

    for (final record in foundSpecies) {
      if (year != null && record.year != year) continue;
      records.putIfAbsent(record.speciesId ?? record.name, () => []).add(record);
    }

    return records.values.map((group) {
      final years = group.map((record) => record.year).whereType<int>().toSet().toList()..sort();

      return StationSpeciesSummary(
        name: group.first.name,
        years: years,
        count: group.fold(0, (sum, record) => sum + record.count),
      );
    }).toList();
  }

  factory StationDetail.fromJson(Map<String, dynamic> json) {
    final species = json['found_species'] as List<dynamic>? ?? const [];
    final physicochemistry = json['physicochemistry'] as List<dynamic>? ?? const [];

    return StationDetail(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      image: json['image'] as String?,
      foundSpecies: species.map((json) => FoundSpecies.fromJson(json as Map<String, dynamic>)).toList(),
      totalSpeciesCount: (json['total_species_count'] as num?)?.toInt() ?? 0,
      totalIndividualsCount: (json['total_individuals_count'] as num?)?.toInt() ?? 0,
      physicochemistry: physicochemistry
          .map((json) => StationPhysicochemistry.fromJson(json as Map<String, dynamic>))
          .toList(),
      years: parseYears(json['years']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'image': image,
      'found_species': foundSpecies.map((species) => species.toJson()).toList(),
      'total_species_count': totalSpeciesCount,
      'total_individuals_count': totalIndividualsCount,
      'physicochemistry': physicochemistry.map((reading) => reading.toJson()).toList(),
      'years': years,
    };
  }
}
