import 'package:diato_ai/core/assets/constants.dart';
import 'package:equatable/equatable.dart';

/// A catalogue row as the list endpoint sends it: no explanation body, only a
/// flag saying whether one is there to read.
class SpeciesSummary extends Equatable {
  final int id;
  final String name;
  final String? image;
  final bool hasContent;
  final int? sensitivity;
  final int? indicator;

  const SpeciesSummary({
    required this.id,
    required this.name,
    this.image,
    this.hasContent = false,
    this.sensitivity,
    this.indicator,
  });

  factory SpeciesSummary.fromJson(Map<String, dynamic> json) {
    return SpeciesSummary(
      id: json['id'] as int,
      name: json['name'] as String,
      image: resolveAssetUrl(json['image'] as String?),
      hasContent: json['has_content'] as bool? ?? false,
      sensitivity: (json['sensitivity'] as num?)?.toInt(),
      indicator: (json['indicator'] as num?)?.toInt(),
    );
  }

  @override
  List<Object?> get props => [id, name, image, hasContent, sensitivity, indicator];
}
