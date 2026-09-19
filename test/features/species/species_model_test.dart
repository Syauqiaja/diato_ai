import 'package:diato_ai/features/diatom_calculator/data/models/catalogue_species.dart';
import 'package:diato_ai/features/scanner/data/models/detected_diatom.dart';
import 'package:diato_ai/features/species/data/models/species_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SpeciesDetail', () {
    test('parses the catalogue detail endpoint', () {
      final detail = SpeciesDetail.fromJson({
        'id': 3,
        'name': 'Cocconeis placentula',
        'image': '/storage/species/a.jpg',
        'sensitivity': 4,
        'indicator': 2,
      });

      expect(detail.id, 3);
      expect(detail.name, 'Cocconeis placentula');
      expect(detail.isScored, isTrue);
      expect(detail.image, contains('/storage/species/a.jpg'));
    });

    test('a species without scores or picture reads as such', () {
      final detail = SpeciesDetail.fromJson({
        'id': 4,
        'name': 'Navicula',
        'image': null,
        'sensitivity': null,
        'indicator': null,
      });

      expect(detail.isScored, isFalse);
      expect(detail.image, isNull);
    });
  });

  group('CatalogueSpecies', () {
    test('parses a row from the catalogue list', () {
      final species = CatalogueSpecies.fromJson({
        'id': 7,
        'name': 'Kaca Cocconeis',
        'image': null,
        'sensitivity': 5,
        'indicator': 3,
      });

      expect(species.isScored, isTrue);
    });
  });

  group('DetectedDiatom', () {
    test('keeps each species in the genus so it can be opened', () {
      final diatom = DetectedDiatom.fromJson({
        'rank': 1,
        'label': 'Cocconeis',
        'confidence': 0.91,
        'species': {'id': 1, 'scientific_name': 'Cocconeis'},
        'genus_species': [
          {'id': 12, 'name': 'Cocconeis placentula'},
        ],
      });

      expect(diatom.genusSpecies.single.id, 12);
      expect(diatom.genusSpecies.single.name, 'Cocconeis placentula');
    });

    test('a label with no catalogue row has nothing to open', () {
      final diatom = DetectedDiatom.fromJson({
        'rank': 1,
        'label': 'Unknown',
        'confidence': 0.4,
        'species': null,
      });

      expect(diatom.genusSpecies, isEmpty);
    });
  });
}
