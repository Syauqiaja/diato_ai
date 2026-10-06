import 'dart:convert';

import 'package:diato_ai/features/scanner/data/models/detected_diatom.dart';
import 'package:diato_ai/features/scanner/data/models/scan_response.dart';
import 'package:flutter_test/flutter_test.dart';

/// The fixture below is a verbatim capture of a real `POST /api/scans`
/// response from the genus-level scanner, so these tests fail if the backend
/// contract drifts.
const _realResponse = '''
{
  "status": true,
  "message": "Diatom genus identified successfully",
  "data": {
    "id": 1,
    "image": "/storage/scans/YsRgxpOOHrbp0TKVsrYFHCRa3Rdt7lbFbSGizpa1.jpg",
    "status": "completed",
    "error_message": null,
    "model_version": "mobilenetv3_large_100-20260919",
    "inference_ms": 80,
    "station_id": null,
    "results": [
      {
        "rank": 1,
        "label": "Cocconeis",
        "confidence": 0.6449,
        "taxon_rank": "genus",
        "species": {
          "id": 1,
          "slug": "Cocconeis",
          "scientific_name": "Cocconeis",
          "authority": null,
          "genus": "Cocconeis",
          "common_name": null,
          "description": "Valves are elliptic.",
          "habitat": "Benthic",
          "size_range": "9-68 um",
          "shape": null,
          "image": "/storage/species/cocconeis.jpg",
          "source_url": null,
          "credit": null
        },
        "genus_species": [
          {
            "id": 1,
            "name": "Cocconeis placentula",
            "image": null,
            "content_title": null,
            "has_content": false,
            "sensitivity": 5,
            "indicator": 3,
            "scannable_species_id": 1
          }
        ],
        "catalogue_species": {
          "id": 1,
          "name": "Cocconeis placentula",
          "image": null,
          "content_title": null,
          "has_content": false,
          "sensitivity": 5,
          "indicator": 3,
          "scannable_species_id": 1
        },
        "scientific_name": "Cocconeis",
        "display_name": "Cocconeis",
        "description": "Valves are elliptic.",
        "habitat": "Benthic",
        "size_range": "9-68 um",
        "shape": null
      },
      {
        "rank": 2,
        "label": "Navicula",
        "confidence": 0.2771,
        "taxon_rank": "genus",
        "species": {
          "id": 2,
          "slug": "Navicula",
          "scientific_name": "Navicula",
          "authority": null,
          "genus": "Navicula",
          "common_name": null,
          "description": null,
          "habitat": null,
          "size_range": null,
          "shape": null,
          "image": null,
          "source_url": null,
          "credit": null
        },
        "genus_species": [
          {
            "id": 2,
            "name": "Navicula cryptocephala",
            "image": null,
            "content_title": null,
            "has_content": false,
            "sensitivity": 4,
            "indicator": 3,
            "scannable_species_id": 2
          },
          {
            "id": 11,
            "name": "Navicula rhynchocephala",
            "image": null,
            "content_title": null,
            "has_content": false,
            "sensitivity": null,
            "indicator": null,
            "scannable_species_id": 2
          }
        ],
        "catalogue_species": {
          "id": 2,
          "name": "Navicula cryptocephala",
          "image": null,
          "content_title": null,
          "has_content": false,
          "sensitivity": 4,
          "indicator": 3,
          "scannable_species_id": 2
        },
        "scientific_name": "Navicula",
        "display_name": "Navicula",
        "description": null,
        "habitat": null,
        "size_range": null,
        "shape": null
      }
    ],
    "created_at": "2026-09-19T07:50:48.000000Z"
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
      expect(scan.modelVersion, 'mobilenetv3_large_100-20260919');
      expect(scan.inferenceMs, 80);
      expect(scan.createdAt, isNotNull);
    });

    test('resolves the relative image path against the asset host', () {
      expect(scan.imageUrl, startsWith('https://'));
      expect(scan.imageUrl, contains('/storage/scans/'));
    });

    test('orders results by rank regardless of array order', () {
      final body = jsonDecode(_realResponse) as Map<String, dynamic>;
      final data = body['data'] as Map<String, dynamic>;
      data['results'] = (data['results'] as List<dynamic>).reversed.toList();
      final reversed = ScanResponse.fromJson(data);

      expect(reversed.results.map((r) => r.rank), [1, 2]);
      expect(reversed.topResult?.name, 'Cocconeis');
      expect(reversed.alternatives.single.name, 'Navicula');
    });

    test('names the result by genus and flattens its detail', () {
      final top = scan.topResult!;
      expect(top.label, 'Cocconeis');
      expect(top.name, 'Cocconeis');
      expect(top.taxonRank, 'genus');
      expect(top.confidence, closeTo(0.6449, 1e-6));
      expect(top.confidencePercent, 64);
      expect(top.habitat, 'Benthic');
      expect(top.hasDetails, isTrue);
      expect(top.imageUrl, startsWith('https://'));
    });

    test('lists the catalogue species in each genus', () {
      expect(scan.topResult!.genusSpecies.map((s) => s.name), ['Cocconeis placentula']);
      final navicula = scan.alternatives.single;
      expect(navicula.genusSpecies.map((s) => s.id), [2, 11]);
      expect(navicula.genusSpecies.first.name, 'Navicula cryptocephala');
    });

    test('tolerates a genus with no catalogue entry', () {
      final diatom = DetectedDiatom.fromJson({
        'rank': 1,
        'label': 'Nowhereia',
        'confidence': 0.42,
        'species': null,
        'genus_species': <dynamic>[],
        'scientific_name': 'Nowhereia',
      });

      expect(diatom.name, 'Nowhereia');
      expect(diatom.hasDetails, isFalse);
      expect(diatom.genusSpecies, isEmpty);
      expect(diatom.imageUrl, isNull);
    });

    test('carries the family the genus is filed under', () {
      final diatom = DetectedDiatom.fromJson({
        'rank': 1,
        'label': 'Navicula',
        'confidence': 0.8,
        'family': {
          'id': 11,
          'type': 'family',
          'title': 'Famili Naviculaceae',
          'cover': null,
          'order': 1,
        },
      });

      expect(diatom.family?.id, 11);
      expect(diatom.family?.title, 'Famili Naviculaceae');
      // Backends from before the family link send no key at all.
      expect(scan.topResult!.family, isNull);
    });

    test('falls back to a readable name when the backend sends only a label', () {
      final diatom = DetectedDiatom.fromJson({
        'rank': 1,
        'label': 'Cocconeis_placentula',
        'confidence': 0.9,
      });

      // A species-era label on an old scan still reads cleanly.
      expect(diatom.name, 'Cocconeis placentula');
      expect(diatom.genusSpecies, isEmpty);
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

    test('reads the diatom and confidence flags from the scan', () {
      final notDiatom = ScanResponse.fromJson({
        'id': 10,
        'status': 'completed',
        'is_diatom': false,
        'is_confident': false,
        'results': <dynamic>[],
      });

      expect(notDiatom.isDiatom, isFalse);
      expect(notDiatom.isConfident, isFalse);
    });

    test('a stored flag wins over the message-based fallback', () {
      final scan = ScanResponse.fromJson(
        {'id': 11, 'status': 'completed', 'is_confident': true, 'results': <dynamic>[]},
        isConfident: false,
      );

      expect(scan.isConfident, isTrue);
    });

    test('scans from before the reject class count as diatoms', () {
      final body = jsonDecode(_realResponse) as Map<String, dynamic>;
      final old = ScanResponse.fromJson(body['data'] as Map<String, dynamic>);

      expect(old.isDiatom, isTrue);
    });
  });
}
