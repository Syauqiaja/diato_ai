import 'package:equatable/equatable.dart';

/// A species from the console-managed catalogue.
///
/// [sensitivity] and [indicator] are the pollution tolerance scores the water
/// quality index is built from. Both are nullable: the catalogue also holds
/// species whose scores have not been filled in yet, and those are recorded
/// but left out of the index.
class CatalogueSpecies extends Equatable {
  final int id;
  final String name;
  final String? image;
  final int? sensitivity;
  final int? indicator;

  const CatalogueSpecies({
    required this.id,
    required this.name,
    this.image,
    this.sensitivity,
    this.indicator,
  });

  /// Whether this species carries the scores the index needs.
  bool get isScored => sensitivity != null && indicator != null;

  factory CatalogueSpecies.fromJson(Map<String, dynamic> json) {
    return CatalogueSpecies(
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['image'] as String?,
      sensitivity: (json['sensitivity'] as num?)?.toInt(),
      indicator: (json['indicator'] as num?)?.toInt(),
    );
  }

  @override
  List<Object?> get props => [id, name, image, sensitivity, indicator];
}
