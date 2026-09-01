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
  /// The backend sets this from the `message` it returns; a low-confidence
  /// answer must be shown as "no confident match", not as an identification.
  final bool isConfident;

  const ScanResponse({
    required this.id,
    required this.status,
    required this.results,
    required this.isConfident,
    this.imageUrl,
    this.modelVersion,
    this.inferenceMs,
    this.createdAt,
  });

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
      isConfident: isConfident,
    );
  }

  DetectedDiatom? get topResult => results.isEmpty ? null : results.first;

  List<DetectedDiatom> get alternatives =>
      results.length <= 1 ? const [] : results.sublist(1);
}
