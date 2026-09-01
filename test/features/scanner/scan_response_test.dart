import 'dart:convert';

import 'package:diato_ai/features/scanner/data/models/detected_diatom.dart';
import 'package:diato_ai/features/scanner/data/models/scan_response.dart';
import 'package:flutter_test/flutter_test.dart';

/// The fixture below is a verbatim capture of a real `POST /api/scans`
/// response, so these tests fail if the backend contract drifts.
const _realResponse = '''
{
  "status": true,
  "message": "Diatom identified successfully",
  "data": {
    "id": 1,
    "image": "/storage/scans/oE4rTey7VRAGrYTiapumlNYkzyuijZzr1m3uoK3Q.jpg",
    "status": "completed",
    "error_message": null,
    "model_version": "mobilenetv3_large_100-20260901",
    "inference_ms": 80,
    "station_id": null,
    "results": [
      {
        "rank": 2,
        "label": "Cocconeis_euglypta",
        "confidence": 0.3525,
        "species": {
          "id": 1, "slug": "Cocconeis_euglypta",
          "scientific_name": "Cocconeis euglypta", "genus": "Cocconeis",
          "description": null, "habitat": null, "size_range": null,
          "shape": null, "image": null
        },
        "scientific_name": "Cocconeis euglypta",
        "description": null, "habitat": null, "size_range": null, "shape": null
      },
      {
        "rank": 1,
        "label": "Cocconeis_placentula",
        "confidence": 0.6449,
        "species": {
          "id": 3, "slug": "Cocconeis_placentula",
          "scientific_name": "Cocconeis placentula", "genus": "Cocconeis",
          "description": "Valves are elliptic.", "habitat": "Benthic",
          "size_range": "9-68 um", "shape": null, "image": "/storage/species/cp.jpg"
        },
        "scientific_name": "Cocconeis placentula",
        "description": "Valves are elliptic.", "habitat": "Benthic",
        "size_range": "9-68 um", "shape": null
      }
    ],
    "created_at": "2026-09-01T14:34:39.000000Z"
  }
}
''';

void main() {
  group('ScanResponse', () {
    late ScanResponse scan;

    setUp(() {
      final body = jsonDecode(_realResponse) as Map<String, dynamic>;
      scan = ScanResponse.fromJson(body['data'] as Map<String, dynamic>);
    });

    test('parses the scan envelope', () {
      expect(scan.id, 1);
      expect(scan.status, 'completed');
      expect(scan.modelVersion, 'mobilenetv3_large_100-20260901');
      expect(scan.inferenceMs, 80);
      expect(scan.createdAt, isNotNull);
    });

    test('resolves the relative image path against the asset host', () {
      expect(scan.imageUrl, startsWith('https://'));
      expect(scan.imageUrl, contains('/storage/scans/'));
    });

    test('orders results by rank regardless of array order', () {
      // The fixture deliberately lists rank 2 before rank 1.
      expect(scan.results.map((r) => r.rank), [1, 2]);
      expect(scan.topResult?.species, 'Cocconeis placentula');
      expect(scan.alternatives.single.species, 'Cocconeis euglypta');
    });

    test('flattens species detail onto the result', () {
      final top = scan.topResult!;
      expect(top.label, 'Cocconeis_placentula');
      expect(top.confidence, closeTo(0.6449, 1e-6));
      expect(top.confidencePercent, 64);
      expect(top.genus, 'Cocconeis');
      expect(top.habitat, 'Benthic');
      expect(top.hasDetails, isTrue);
      expect(top.imageUrl, startsWith('https://'));
    });

    test('tolerates a species with no catalogue entry', () {
      final diatom = DetectedDiatom.fromJson({
        'rank': 1,
        'label': 'Navicula_nowhere',
        'confidence': 0.42,
        'species': null,
        'scientific_name': 'Navicula nowhere',
      });

      expect(diatom.species, 'Navicula nowhere');
      expect(diatom.hasDetails, isFalse);
      expect(diatom.genus, isNull);
      expect(diatom.imageUrl, isNull);
    });

    test('falls back to a readable name when the backend sends only a label', () {
      final diatom = DetectedDiatom.fromJson({
        'rank': 1,
        'label': 'Cocconeis_placentula',
        'confidence': 0.9,
      });

      expect(diatom.species, 'Cocconeis placentula');
    });

    test('carries the low-confidence flag through', () {
      final body = jsonDecode(_realResponse) as Map<String, dynamic>;
      final unsure = ScanResponse.fromJson(
        body['data'] as Map<String, dynamic>,
        isConfident: false,
      );

      expect(unsure.isConfident, isFalse);
    });

    test('handles an empty result list', () {
      final empty = ScanResponse.fromJson({
        'id': 9,
        'status': 'completed',
        'results': <dynamic>[],
      });

      expect(empty.results, isEmpty);
      expect(empty.topResult, isNull);
      expect(empty.alternatives, isEmpty);
    });
  });
}
