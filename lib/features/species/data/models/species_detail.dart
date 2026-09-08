import 'package:diato_ai/core/assets/constants.dart';
import 'package:equatable/equatable.dart';

/// One catalogue species with its long-form explanation.
///
/// [content] is the HTML written in the console; it is null for species whose
/// explanation has not been written yet.
class SpeciesDetail extends Equatable {
  final int id;
  final String name;
  final String? image;
  final String? content;
  final int? sensitivity;
  final int? indicator;

  const SpeciesDetail({
    required this.id,
    required this.name,
    this.image,
    this.content,
    this.sensitivity,
    this.indicator,
  });

  bool get hasContent => (content ?? '').trim().isNotEmpty;

  bool get isScored => sensitivity != null && indicator != null;

  factory SpeciesDetail.fromJson(Map<String, dynamic> json) {
    return SpeciesDetail(
      id: json['id'] as int,
      name: json['name'] as String,
      image: resolveAssetUrl(json['image'] as String?),
      content: json['content'] as String?,
      sensitivity: (json['sensitivity'] as num?)?.toInt(),
      indicator: (json['indicator'] as num?)?.toInt(),
    );
  }

  @override
  List<Object?> get props => [id, name, image, content, sensitivity, indicator];
}
