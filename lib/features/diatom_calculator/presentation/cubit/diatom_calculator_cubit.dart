import 'package:bloc/bloc.dart';
import 'package:diato_ai/core/data/result.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/catalogue_species.dart';
import '../../domain/brdi_calculator.dart';
import '../../domain/repositories/diatom_calculator_repository.dart';

part 'diatom_calculator_state.dart';

/// Drives the calculator screen: the species catalogue comes from the server,
/// but the index itself is worked out here on the device after every edit.
class DiatomCalculatorCubit extends Cubit<DiatomCalculatorState> {
  final DiatomCalculatorRepository _repository;

  DiatomCalculatorCubit(this._repository)
    : super(const DiatomCalculatorState());

  Future<void> loadCatalogue() async {
    emit(state.copyWith(catalogueStatus: CatalogueStatus.loading));

    final result = await _repository.getCatalogue();

    switch (result) {
      case Success<List<CatalogueSpecies>>():
        emit(
          state.copyWith(
            catalogueStatus: CatalogueStatus.loaded,
            catalogue: result.value,
          ),
        );
      case Failure<List<CatalogueSpecies>>():
        emit(
          state.copyWith(
            catalogueStatus: CatalogueStatus.error,
            catalogueError: result.message,
          ),
        );
    }
  }

  void search(String query) => emit(state.copyWith(query: query));

  void setLocation(String location) => emit(state.copyWith(location: location));

  void addSpecies(CatalogueSpecies species) {
    if (state.entries.any((entry) => entry.species.id == species.id)) {
      emit(state.copyWith(query: ''));
      return;
    }

    _emitWithEntries([
      ...state.entries,
      SpeciesEntry(species: species, count: 1),
    ], query: '');
  }

  void updateCount(int speciesId, int count) {
    final entries = state.entries
        .map(
          (entry) => entry.species.id == speciesId
              ? entry.copyWith(count: count < 0 ? 0 : count)
              : entry,
        )
        .toList();

    _emitWithEntries(entries);
  }

  void removeSpecies(int speciesId) {
    _emitWithEntries(
      state.entries.where((entry) => entry.species.id != speciesId).toList(),
    );
  }

  /// Clears the counts so the next sampling point starts from nothing. The
  /// catalogue is kept: it did not change just because a reading was finished.
  void reset() {
    emit(
      state.copyWith(
        entries: const [],
        query: '',
        location: '',
        result: const BrdiResult(di: null, contributions: []),
        saveStatus: SaveStatus.idle,
      ),
    );
  }

  Future<void> save() async {
    if (!state.hasResult || state.saveStatus == SaveStatus.saving) return;

    emit(state.copyWith(saveStatus: SaveStatus.saving));

    final location = state.location.trim();
    final result = await _repository.saveCalculation(
      location: location.isEmpty ? null : location,
      result: state.result,
      entries: state.entries,
    );

    emit(
      result.isSuccess
          ? state.copyWith(saveStatus: SaveStatus.saved)
          : state.copyWith(
              saveStatus: SaveStatus.error,
              saveError: result.errorMessage,
            ),
    );
  }

  /// Recomputes the index for [entries] and emits both together, so the counts
  /// and the number shown under them can never drift apart.
  void _emitWithEntries(List<SpeciesEntry> entries, {String? query}) {
    emit(
      state.copyWith(
        entries: entries,
        query: query ?? state.query,
        result: BrdiCalculator.calculate(entries),
        // A saved reading no longer describes what is on screen once the
        // counts behind it change.
        saveStatus: SaveStatus.idle,
      ),
    );
  }
}
