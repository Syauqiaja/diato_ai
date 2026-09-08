import 'package:diato_ai/features/diatom_calculator/data/models/catalogue_species.dart';
import 'package:diato_ai/features/scanner/data/models/detected_diatom.dart';
import 'package:diato_ai/features/species/data/models/species_detail.dart';
import 'package:diato_ai/features/species/data/models/species_summary.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SpeciesDetail', () {
    test('parses the explanation sent by the catalogue detail endpoint', () {
      final detail = SpeciesDetail.fromJson({
        'id': 3,
        'name': 'Kaca Cocconeis',
        'image': '/storage/species/a.jpg',
        'content': '<h2>Habitat</h2><p>Batu di arus deras.</p>',
        'sensitivity': 4,
        'indicator': 2,
      });

      expect(detail.id, 3);
      expect(detail.content, '<h2>Habitat</h2><p>Batu di arus deras.</p>');
      expect(detail.hasContent, isTrue);
      expect(detail.isScored, isTrue);
      expect(detail.image, contains('/storage/species/a.jpg'));
    });

    test('a species with no explanation written reads as empty', () {
      final detail = SpeciesDetail.fromJson({
        'id': 4,
        'name': 'Navicula',
        'image': null,
        'content': null,
        'sensitivity': null,
        'indicator': null,
      });

      expect(detail.hasContent, isFalse);
      expect(detail.isScored, isFalse);
      expect(detail.image, isNull);
    });
  });

  group('SpeciesSummary', () {
    test('carries the flag saying an explanation is there to read', () {
      final written = SpeciesSummary.fromJson({
        'id': 1,
        'name': 'Kaca Cocconeis',
        'image': null,
        'has_content': true,
        'sensitivity': 5,
        'indicator': 3,
      });
      final unwritten = SpeciesSummary.fromJson({
        'id': 2,
        'name': 'Navicula',
        'image': null,
        'has_content': false,
      });

      expect(written.hasContent, isTrue);
      expect(unwritten.hasContent, isFalse);
    });

    test('an older backend without the flag reads as nothing to open', () {
      final species = SpeciesSummary.fromJson({'id': 9, 'name': 'Cymbella'});

      expect(species.hasContent, isFalse);
    });
  });

  group('CatalogueSpecies', () {
    test('picks up the explanation flag from the catalogue list', () {
      final species = CatalogueSpecies.fromJson({
        'id': 7,
        'name': 'Kaca Cocconeis',
        'image': null,
        'has_content': true,
        'sensitivity': 5,
        'indicator': 3,
      });

      expect(species.hasContent, isTrue);
      expect(species.isScored, isTrue);
    });
  });

  group('DetectedDiatom', () {
    test('keeps the catalogue id so the explanation can be opened', () {
      final diatom = DetectedDiatom.fromJson({
        'rank': 1,
        'label': 'Cocconeis_placentula',
        'confidence': 0.91,
        'species': {'id': 1, 'scientific_name': 'Cocconeis placentula'},
        'catalogue_species': {'id': 12, 'name': 'Kaca Cocconeis'},
      });

      expect(diatom.catalogueSpeciesId, 12);
    });

    test('a label with no catalogue row has nothing to open', () {
      final diatom = DetectedDiatom.fromJson({
        'rank': 1,
        'label': 'Unknown_class',
        'confidence': 0.4,
        'species': null,
        'catalogue_species': null,
      });

      expect(diatom.catalogueSpeciesId, isNull);
    });
  });
}
