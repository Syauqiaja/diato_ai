import 'package:diato_ai/core/assets/constants.dart';
import 'package:diato_ai/features/shared/models/found_species.dart';

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
  });

  /// Absolute url for [image]. See [Station.imageUrl].
  String? get imageUrl => resolveAssetUrl(image);

  factory StationDetail.fromJson(Map<String, dynamic> json) {
    final species = json['found_species'] as List<dynamic>? ?? const [];

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
    };
  }
}
