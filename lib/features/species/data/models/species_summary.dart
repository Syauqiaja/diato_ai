import 'package:diato_ai/core/assets/constants.dart';
import 'package:equatable/equatable.dart';

/// A catalogue row as a list sends it, such as the species filed under a
/// scanned genus.
class SpeciesSummary extends Equatable {
  final int id;
  final String name;
  final String? image;
  final int? sensitivity;
  final int? indicator;

  const SpeciesSummary({
    required this.id,
    required this.name,
    this.image,
    this.sensitivity,
    this.indicator,
  });

  factory SpeciesSummary.fromJson(Map<String, dynamic> json) {
    return SpeciesSummary(
      id: json['id'] as int,
      name: json['name'] as String,
      image: resolveAssetUrl(json['image'] as String?),
      sensitivity: (json['sensitivity'] as num?)?.toInt(),
      indicator: (json['indicator'] as num?)?.toInt(),
    );
  }

  @override
  List<Object?> get props => [id, name, image, sensitivity, indicator];
}
