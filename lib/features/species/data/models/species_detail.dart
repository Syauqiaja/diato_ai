import 'package:diato_ai/core/assets/constants.dart';
import 'package:equatable/equatable.dart';

/// One catalogue species: its picture and the pollution tolerance scores.
///
/// The write-ups that used to hang off a species are families now, read
/// through the contents endpoints.
class SpeciesDetail extends Equatable {
  final int id;
  final String name;
  final String? image;
  final int? sensitivity;
  final int? indicator;

  const SpeciesDetail({
    required this.id,
    required this.name,
    this.image,
    this.sensitivity,
    this.indicator,
  });

  bool get isScored => sensitivity != null && indicator != null;

  factory SpeciesDetail.fromJson(Map<String, dynamic> json) {
    return SpeciesDetail(
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
