import 'package:diato_ai/core/assets/constants.dart';

/// One candidate identification returned by the CNN, ranked by confidence.
class DetectedDiatom {
  /// Raw model class label, e.g. `Cocconeis_placentula`.
  final String label;

  /// Display name — the catalogue's scientific name when the label resolves to
  /// a species row, otherwise the label with underscores removed.
  final String species;

  /// 1 is the model's best guess.
  final int rank;

  /// Softmax probability in 0..1.
  final double confidence;

  final String? description;
  final String? habitat;
  final String? size;
  final String? shape;
  final String? genus;
  final String? imageUrl;

  const DetectedDiatom({
    required this.label,
    required this.species,
    required this.rank,
    required this.confidence,
    this.description,
    this.habitat,
    this.size,
    this.shape,
    this.genus,
    this.imageUrl,
  });

  factory DetectedDiatom.fromJson(Map<String, dynamic> json) {
    final species = json['species'] as Map<String, dynamic>?;

    return DetectedDiatom(
      label: json['label'] as String? ?? '',
      species:
          json['scientific_name'] as String? ??
          species?['scientific_name'] as String? ??
          (json['label'] as String? ?? '').replaceAll('_', ' '),
      rank: (json['rank'] as num?)?.toInt() ?? 0,
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String? ?? species?['description'] as String?,
      habitat: json['habitat'] as String? ?? species?['habitat'] as String?,
      size: json['size_range'] as String? ?? species?['size_range'] as String?,
      shape: json['shape'] as String? ?? species?['shape'] as String?,
      genus: species?['genus'] as String?,
      imageUrl: resolveAssetUrl(species?['image'] as String?),
    );
  }

  /// Confidence as a whole percentage, for display.
  int get confidencePercent => (confidence * 100).round();

  /// True when the backend could not match this label to a catalogue entry, so
  /// only the name and confidence are available.
  bool get hasDetails => description != null || habitat != null || size != null;
}
