import 'package:diato_ai/core/assets/constants.dart';
import 'package:diato_ai/features/contents/data/models/content_item.dart';
import 'package:diato_ai/features/species/data/models/species_summary.dart';

/// One candidate identification returned by the CNN, ranked by confidence.
///
/// The model identifies GENERA, not species: [name] is a genus such as
/// `Navicula`, and [genusSpecies] lists the catalogue species filed under it.
class DetectedDiatom {
  /// Raw model class label, e.g. `Navicula`.
  final String label;

  /// Display name — the genus. Falls back to the label with underscores
  /// removed when the backend has no row for it.
  final String name;

  /// Taxonomic rank of [name]; `genus` for every current model.
  final String taxonRank;

  /// 1 is the model's best guess.
  final int rank;

  /// Softmax probability in 0..1.
  final double confidence;

  final String? description;
  final String? habitat;
  final String? size;
  final String? shape;
  final String? imageUrl;

  /// Catalogue species in this genus, each with an explanation to open.
  final List<SpeciesSummary> genusSpecies;

  /// The family write-up this genus is filed under; null until one is
  /// assigned in the console.
  final ContentItem? family;

  const DetectedDiatom({
    required this.label,
    required this.name,
    required this.rank,
    required this.confidence,
    this.taxonRank = 'genus',
    this.description,
    this.habitat,
    this.size,
    this.shape,
    this.imageUrl,
    this.genusSpecies = const [],
    this.family,
  });

  factory DetectedDiatom.fromJson(Map<String, dynamic> json) {
    final genus = json['species'] as Map<String, dynamic>?;
    final family = json['family'] as Map<String, dynamic>?;

    return DetectedDiatom(
      label: json['label'] as String? ?? '',
      name:
          json['display_name'] as String? ??
          json['scientific_name'] as String? ??
          genus?['scientific_name'] as String? ??
          (json['label'] as String? ?? '').replaceAll('_', ' '),
      taxonRank: json['taxon_rank'] as String? ?? 'genus',
      rank: (json['rank'] as num?)?.toInt() ?? 0,
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String? ?? genus?['description'] as String?,
      habitat: json['habitat'] as String? ?? genus?['habitat'] as String?,
      size: json['size_range'] as String? ?? genus?['size_range'] as String?,
      shape: json['shape'] as String? ?? genus?['shape'] as String?,
      imageUrl: resolveAssetUrl(genus?['image'] as String?),
      genusSpecies: (json['genus_species'] as List<dynamic>? ?? const [])
          .map((e) => SpeciesSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
      family: family == null ? null : ContentItem.fromJson(family),
    );
  }

  /// Confidence as a whole percentage, for display.
  int get confidencePercent => (confidence * 100).round();

  /// True when the backend could not match this label to a catalogue entry, so
  /// only the name and confidence are available.
  bool get hasDetails => description != null || habitat != null || size != null;
}
