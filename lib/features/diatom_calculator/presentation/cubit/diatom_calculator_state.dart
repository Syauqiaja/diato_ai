part of 'diatom_calculator_cubit.dart';

enum CatalogueStatus { initial, loading, loaded, error }

enum SaveStatus { idle, saving, saved, error }

class DiatomCalculatorState extends Equatable {
  final CatalogueStatus catalogueStatus;
  final List<CatalogueSpecies> catalogue;
  final String? catalogueError;

  /// What the user has counted so far, in the order it was added.
  final List<SpeciesEntry> entries;
  final String query;
  final String location;

  /// Recomputed on the device after every change, so the index on screen
  /// always matches the counts above it.
  final BrdiResult result;

  final SaveStatus saveStatus;
  final String? saveError;

  const DiatomCalculatorState({
    this.catalogueStatus = CatalogueStatus.initial,
    this.catalogue = const [],
    this.catalogueError,
    this.entries = const [],
    this.query = '',
    this.location = '',
    this.result = const BrdiResult(di: null, contributions: []),
    this.saveStatus = SaveStatus.idle,
    this.saveError,
  });

  /// Catalogue matches for the current query, minus anything already counted.
  List<CatalogueSpecies> get suggestions {
    final term = query.trim().toLowerCase();
    if (term.isEmpty) return const [];

    return catalogue
        .where(
          (species) =>
              species.name.toLowerCase().contains(term) &&
              !entries.any((entry) => entry.species.id == species.id),
        )
        .take(6)
        .toList();
  }

  /// How many counted species carry the scores the index is built from.
  int get scoredCount => entries.where((entry) => entry.species.isScored).length;

  bool get hasResult => result.di != null;

  DiatomCalculatorState copyWith({
    CatalogueStatus? catalogueStatus,
    List<CatalogueSpecies>? catalogue,
    String? catalogueError,
    List<SpeciesEntry>? entries,
    String? query,
    String? location,
    BrdiResult? result,
    SaveStatus? saveStatus,
    String? saveError,
  }) {
    return DiatomCalculatorState(
      catalogueStatus: catalogueStatus ?? this.catalogueStatus,
      catalogue: catalogue ?? this.catalogue,
      catalogueError: catalogueError,
      entries: entries ?? this.entries,
      query: query ?? this.query,
      location: location ?? this.location,
      result: result ?? this.result,
      saveStatus: saveStatus ?? this.saveStatus,
      saveError: saveError,
    );
  }

  @override
  List<Object?> get props => [
        catalogueStatus,
        catalogue,
        catalogueError,
        entries,
        query,
        location,
        result,
        saveStatus,
        saveError,
      ];
}
