import 'package:diato_ai/features/diatom_calculator/data/models/catalogue_species.dart';
import 'package:diato_ai/features/diatom_calculator/domain/brdi_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

CatalogueSpecies _species(
  String name, {
  int? sensitivity,
  int? indicator,
  int id = 0,
}) {
  return CatalogueSpecies(
    id: id,
    name: name,
    sensitivity: sensitivity,
    indicator: indicator,
  );
}

void main() {
  group('BrdiCalculator.calculate', () {
    test('weights each species by count x indicator x sensitivity', () {
      final result = BrdiCalculator.calculate([
        SpeciesEntry(
          species: _species('Cocconeis placentula', sensitivity: 5, indicator: 3, id: 1),
          count: 10,
        ),
        SpeciesEntry(
          species: _species('Nitzschia tryblionella', sensitivity: 1, indicator: 1, id: 2),
          count: 5,
        ),
      ]);

      // (10*3*5 + 5*1*1) / (10*3 + 5*1) = 155 / 35
      expect(result.di, closeTo(155 / 35, 1e-9));
      expect(result.contributions, hasLength(2));
    });

    test('excludes species with a null sensitivity', () {
      final result = BrdiCalculator.calculate([
        SpeciesEntry(
          species: _species('Cocconeis placentula', sensitivity: 4, indicator: 2, id: 1),
          count: 3,
        ),
        SpeciesEntry(
          species: _species('Melosira granulata', sensitivity: null, indicator: 3, id: 2),
          count: 8,
        ),
      ]);

      expect(result.di, closeTo(4, 1e-9));
      expect(result.contributions.map((c) => c.species.name), ['Cocconeis placentula']);
    });

    test('excludes species with a null indicator', () {
      final result = BrdiCalculator.calculate([
        SpeciesEntry(
          species: _species('Cocconeis placentula', sensitivity: 4, indicator: 2, id: 1),
          count: 3,
        ),
        SpeciesEntry(
          species: _species('Synedra ulna', sensitivity: 5, indicator: null, id: 2),
          count: 8,
        ),
      ]);

      expect(result.di, closeTo(4, 1e-9));
      expect(result.contributions.map((c) => c.species.name), ['Cocconeis placentula']);
    });

    test('excludes species whose count is zero or negative', () {
      final result = BrdiCalculator.calculate([
        SpeciesEntry(
          species: _species('Cocconeis placentula', sensitivity: 4, indicator: 2, id: 1),
          count: 3,
        ),
        SpeciesEntry(
          species: _species('Gomphonema parvulum', sensitivity: 2, indicator: 2, id: 2),
          count: 0,
        ),
      ]);

      expect(result.di, closeTo(4, 1e-9));
      expect(result.contributions, hasLength(1));
    });

    test('returns a null index when nothing scoreable was entered', () {
      final empty = BrdiCalculator.calculate([]);
      expect(empty.di, isNull);
      expect(empty.category, isNull);
      expect(empty.contributions, isEmpty);

      final unscored = BrdiCalculator.calculate([
        SpeciesEntry(species: _species('Melosira granulata', id: 1), count: 4),
      ]);
      expect(unscored.di, isNull);
      expect(unscored.category, isNull);
    });
  });

  group('BrdiCategory.forIndex', () {
    test('maps each band to its category', () {
      expect(BrdiCategory.forIndex(1.0), BrdiCategory.sangatBuruk);
      expect(BrdiCategory.forIndex(2.0), BrdiCategory.buruk);
      expect(BrdiCategory.forIndex(3.0), BrdiCategory.sedang);
      expect(BrdiCategory.forIndex(4.0), BrdiCategory.baik);
      expect(BrdiCategory.forIndex(5.0), BrdiCategory.sangatBaik);
    });

    test('treats each boundary as the start of the higher band', () {
      expect(BrdiCategory.forIndex(1.5), BrdiCategory.buruk);
      expect(BrdiCategory.forIndex(2.5), BrdiCategory.sedang);
      expect(BrdiCategory.forIndex(3.5), BrdiCategory.baik);
      expect(BrdiCategory.forIndex(4.5), BrdiCategory.sangatBaik);
    });

    test('reads a stored category back from its wire value', () {
      expect(BrdiCategory.fromValue('sedang'), BrdiCategory.sedang);
      expect(BrdiCategory.fromValue('sangat_baik'), BrdiCategory.sangatBaik);
      expect(BrdiCategory.fromValue('unknown'), isNull);
    });
  });
}
