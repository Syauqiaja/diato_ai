import 'package:diato_ai/core/assets/constants.dart';
import 'package:equatable/equatable.dart';

/// A catalogue row as the list endpoint sends it: no explanation body, only a
/// flag saying whether one is there to read.
class SpeciesSummary extends Equatable {
  final int id;
  final String name;
  final String? image;

  /// Headline written for the explanation; the species name stands in when the
  /// console left it empty.
  final String? contentTitle;
  final bool hasContent;
  final int? sensitivity;
  final int? indicator;

  const SpeciesSummary({
    required this.id,
    required this.name,
    this.image,
    this.contentTitle,
    this.hasContent = false,
    this.sensitivity,
    this.indicator,
  });

  factory SpeciesSummary.fromJson(Map<String, dynamic> json) {
    return SpeciesSummary(
      id: json['id'] as int,
      name: json['name'] as String,
      image: resolveAssetUrl(json['image'] as String?),
      contentTitle: json['content_title'] as String?,
      hasContent: json['has_content'] as bool? ?? false,
      sensitivity: (json['sensitivity'] as num?)?.toInt(),
      indicator: (json['indicator'] as num?)?.toInt(),
    );
  }

  /// What to show as the heading of this species in a list.
  String get title =>
      (contentTitle ?? '').trim().isEmpty ? name : contentTitle!.trim();

  @override
  List<Object?> get props => [id, name, image, contentTitle, hasContent, sensitivity, indicator];
}
