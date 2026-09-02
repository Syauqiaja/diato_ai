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

    test('counts a null sensitivity as zero, keeping the species in', () {
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

      // (3*2*4 + 8*3*0) / (3*2 + 8*3) = 24 / 30
      expect(result.di, closeTo(24 / 30, 1e-9));
      expect(
        result.contributions.map((c) => c.species.name),
        ['Cocconeis placentula', 'Melosira granulata'],
      );
    });

    test('counts a null indicator as zero, so the species carries no weight', () {
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

      // The second species weighs 8*0 = 0, so it moves neither sum.
      expect(result.di, closeTo(4, 1e-9));
      expect(result.contributions, hasLength(2));
      expect(result.contributions.last.weight, 0);
      expect(result.contributions.last.score, 0);
    });

    test('treats a zero score the same as a missing one', () {
      final nullScores = BrdiCalculator.calculate([
        SpeciesEntry(
          species: _species('Cocconeis placentula', sensitivity: 4, indicator: 2, id: 1),
          count: 3,
        ),
        SpeciesEntry(species: _species('Melosira granulata', id: 2), count: 8),
      ]);
      final zeroScores = BrdiCalculator.calculate([
        SpeciesEntry(
          species: _species('Cocconeis placentula', sensitivity: 4, indicator: 2, id: 1),
          count: 3,
        ),
        SpeciesEntry(
          species: _species('Melosira granulata', sensitivity: 0, indicator: 0, id: 2),
          count: 8,
        ),
      ]);

      expect(nullScores.di, zeroScores.di);
    });

    test('keeps a zero count in the breakdown at no weight', () {
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
      expect(result.contributions, hasLength(2));
      expect(result.contributions.last.weight, 0);
    });

    test('tops out the scale when nothing counted carries weight', () {
      final result = BrdiCalculator.calculate([
        SpeciesEntry(species: _species('Melosira granulata', id: 1), count: 4),
      ]);

      // Nothing found points to poor water, and it is still a real result:
      // the reading can be shown and saved.
      expect(result.di, 5);
      expect(result.category, BrdiCategory.sangatBaik);
      expect(result.contributions, hasLength(1));
    });

    test('tops out the scale when every count is zero', () {
      final result = BrdiCalculator.calculate([
        SpeciesEntry(
          species: _species('Cocconeis placentula', sensitivity: 1, indicator: 3, id: 1),
          count: 0,
        ),
      ]);

      expect(result.di, 5);
    });

    test('has no index at all until something is counted', () {
      final empty = BrdiCalculator.calculate([]);
      expect(empty.di, isNull);
      expect(empty.category, isNull);
      expect(empty.contributions, isEmpty);
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
