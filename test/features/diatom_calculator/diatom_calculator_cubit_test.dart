import 'package:diato_ai/core/data/result.dart';
import 'package:diato_ai/features/diatom_calculator/data/models/catalogue_species.dart';
import 'package:diato_ai/features/diatom_calculator/data/models/saved_calculation.dart';
import 'package:diato_ai/features/diatom_calculator/domain/brdi_calculator.dart';
import 'package:diato_ai/features/diatom_calculator/domain/repositories/diatom_calculator_repository.dart';
import 'package:diato_ai/features/diatom_calculator/presentation/cubit/diatom_calculator_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

const _cocconeis = CatalogueSpecies(
  id: 1,
  name: 'Cocconeis placentula',
  sensitivity: 5,
  indicator: 3,
);
const _nitzschia = CatalogueSpecies(
  id: 2,
  name: 'Nitzschia tryblionella',
  sensitivity: 1,
  indicator: 1,
);
const _unscored = CatalogueSpecies(id: 3, name: 'Melosira granulata');

class _FakeRepository extends DiatomCalculatorRepository {
  List<SpeciesEntry>? savedEntries;
  String? savedLocation;
  bool saveFails = false;

  @override
  Future<Result<List<CatalogueSpecies>>> getCatalogue() async {
    return Result.success(const [_cocconeis, _nitzschia, _unscored]);
  }

  @override
  Future<Result<List<SavedCalculation>>> getSavedCalculations() async {
    return Result.success(const []);
  }

  @override
  Future<Result<SavedCalculation>> saveCalculation({
    required String? location,
    required BrdiResult result,
    required List<SpeciesEntry> entries,
  }) async {
    if (saveFails) return Result.failure('server said no');

    savedEntries = entries;
    savedLocation = location;
    return Result.success(
      SavedCalculation(
        id: 1,
        location: location,
        di: result.di!,
        category: result.category,
        createdAt: DateTime(2026, 9, 2),
        entries: const [],
      ),
    );
  }

  @override
  Future<Result<void>> deleteCalculation(int id) async => Result.success(null);
}

void main() {
  late _FakeRepository repository;
  late DiatomCalculatorCubit cubit;

  setUp(() {
    repository = _FakeRepository();
    cubit = DiatomCalculatorCubit(repository);
  });

  tearDown(() => cubit.close());

  test('recomputes the index as species are added and counted', () async {
    await cubit.loadCatalogue();
    expect(cubit.state.catalogueStatus, CatalogueStatus.loaded);

    cubit.addSpecies(_cocconeis);
    expect(cubit.state.result.di, 5);

    cubit.updateCount(_cocconeis.id, 10);
    cubit.addSpecies(_nitzschia);
    cubit.updateCount(_nitzschia.id, 5);

    // (10*3*5 + 5*1*1) / (10*3 + 5*1)
    expect(cubit.state.result.di, closeTo(155 / 35, 1e-9));
  });

  test('keeps an unscored species in the reading at zero weight', () async {
    await cubit.loadCatalogue();

    cubit.addSpecies(_cocconeis);
    cubit.addSpecies(_unscored);
    cubit.updateCount(_unscored.id, 40);

    expect(cubit.state.entries, hasLength(2));
    expect(cubit.state.scoredCount, 1);
    // However many were found, a species with no scores moves nothing.
    expect(cubit.state.result.di, 5);
    expect(cubit.state.result.contributions, hasLength(2));
  });

  test('drops a species and the weight it carried', () async {
    await cubit.loadCatalogue();

    cubit.addSpecies(_cocconeis);
    cubit.addSpecies(_nitzschia);
    cubit.removeSpecies(_cocconeis.id);

    expect(cubit.state.entries.single.species, _nitzschia);
    expect(cubit.state.result.di, 1);
  });

  test('will not add the same species twice', () async {
    await cubit.loadCatalogue();

    cubit.addSpecies(_cocconeis);
    cubit.updateCount(_cocconeis.id, 7);
    cubit.addSpecies(_cocconeis);

    expect(cubit.state.entries, hasLength(1));
    expect(cubit.state.entries.single.count, 7);
  });

  test('offers matches for the query, minus what is already counted', () async {
    await cubit.loadCatalogue();

    cubit.search('nitz');
    expect(cubit.state.suggestions, [_nitzschia]);

    cubit.addSpecies(_nitzschia);
    cubit.search('nitz');
    expect(cubit.state.suggestions, isEmpty);
  });

  test('sends every counted species when saving, scored or not', () async {
    await cubit.loadCatalogue();

    cubit.addSpecies(_cocconeis);
    cubit.addSpecies(_unscored);
    cubit.setLocation('  Stasiun I  ');
    await cubit.save();

    expect(cubit.state.saveStatus, SaveStatus.saved);
    expect(repository.savedLocation, 'Stasiun I');
    expect(
      repository.savedEntries?.map((e) => e.species.name),
      ['Cocconeis placentula', 'Melosira granulata'],
    );
  });

  test('saves a reading made only of unscored species', () async {
    await cubit.loadCatalogue();

    cubit.addSpecies(_unscored);
    expect(cubit.state.result.di, 0);

    await cubit.save();

    expect(cubit.state.saveStatus, SaveStatus.saved);
    expect(repository.savedEntries, hasLength(1));
  });

  test('has nothing to save until a species is counted', () async {
    await cubit.loadCatalogue();

    await cubit.save();

    expect(cubit.state.saveStatus, SaveStatus.idle);
    expect(repository.savedEntries, isNull);
  });

  test('surfaces a save failure', () async {
    repository.saveFails = true;
    await cubit.loadCatalogue();

    cubit.addSpecies(_cocconeis);
    await cubit.save();

    expect(cubit.state.saveStatus, SaveStatus.error);
    expect(cubit.state.saveError, 'server said no');
  });

  test('editing counts clears a stale saved marker', () async {
    await cubit.loadCatalogue();

    cubit.addSpecies(_cocconeis);
    await cubit.save();
    expect(cubit.state.saveStatus, SaveStatus.saved);

    cubit.updateCount(_cocconeis.id, 4);
    expect(cubit.state.saveStatus, SaveStatus.idle);
  });

  test('reset clears the counts but keeps the catalogue', () async {
    await cubit.loadCatalogue();

    cubit.addSpecies(_cocconeis);
    cubit.setLocation('Stasiun I');
    cubit.reset();

    expect(cubit.state.entries, isEmpty);
    expect(cubit.state.location, '');
    expect(cubit.state.result.di, isNull);
    expect(cubit.state.catalogue, hasLength(3));
  });
}
