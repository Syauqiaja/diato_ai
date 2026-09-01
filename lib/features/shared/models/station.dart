import 'package:diato_ai/core/assets/constants.dart';

final class Station {
  final int id;
  final String title;
  final String description;
  final double latitude;
  final double longitude;
  final String? image;
  final int speciesCount;

  Station({
    required this.id,
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.image,
    required this.speciesCount,
  });

  /// Absolute url for [image]. The API returns a root-relative `/storage/...`
  /// path when the backend has no `APP_URL` configured.
  String? get imageUrl => resolveAssetUrl(image);

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      image: json['image'] as String?,
      speciesCount: (json['species_count'] as num?)?.toInt() ?? 0,
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
      'species_count': speciesCount,
    };
  }
}
