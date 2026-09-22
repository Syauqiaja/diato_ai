import 'package:diato_ai/core/assets/constants.dart';
import 'package:diato_ai/features/scanner/data/models/detected_diatom.dart';

/// The result of uploading one image to `POST /scans`.
class ScanResponse {
  final int id;
  final String? imageUrl;
  final String status;
  final String? modelVersion;
  final int? inferenceMs;
  final DateTime? createdAt;

  /// Candidates, already ordered by rank (best first).
  final List<DetectedDiatom> results;

  /// True when the top candidate cleared the model's confidence threshold.
  /// A low-confidence answer must be shown as "no confident match", not as an
  /// identification.
  final bool isConfident;

  /// False when the model found no diatom in the photo at all (a face, a room,
  /// an empty field of view). [results] is then empty.
  final bool isDiatom;

  const ScanResponse({
    required this.id,
    required this.status,
    required this.results,
    required this.isConfident,
    this.isDiatom = true,
    this.imageUrl,
    this.modelVersion,
    this.inferenceMs,
    this.createdAt,
  });

  /// [isConfident] is the fallback for scans made before the backend stored
  /// `is_confident`, which leave the field null.
  factory ScanResponse.fromJson(
    Map<String, dynamic> json, {
    bool isConfident = true,
  }) {
    final results = (json['results'] as List<dynamic>? ?? [])
        .map((e) => DetectedDiatom.fromJson(e as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => a.rank.compareTo(b.rank));

    return ScanResponse(
      id: (json['id'] as num?)?.toInt() ?? 0,
      imageUrl: resolveAssetUrl(json['image'] as String?),
      status: json['status'] as String? ?? 'completed',
      modelVersion: json['model_version'] as String?,
      inferenceMs: (json['inference_ms'] as num?)?.toInt(),
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? ''),
      results: results,
      isConfident: json['is_confident'] as bool? ?? isConfident,
      isDiatom: json['is_diatom'] as bool? ?? true,
    );
  }

  DetectedDiatom? get topResult => results.isEmpty ? null : results.first;

  List<DetectedDiatom> get alternatives =>
      results.length <= 1 ? const [] : results.sublist(1);
}
