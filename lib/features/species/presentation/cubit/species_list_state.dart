part of 'species_list_cubit.dart';

sealed class SpeciesListState extends Equatable {
  const SpeciesListState();

  @override
  List<Object> get props => [];
}

final class SpeciesListInitial extends SpeciesListState {}

final class SpeciesListLoading extends SpeciesListState {}

final class SpeciesListData extends SpeciesListState {
  final List<SpeciesSummary> species;
  const SpeciesListData(this.species);

  /// Only the species worth opening: the ones with an explanation written.
  List<SpeciesSummary> get explained =>
      species.where((s) => s.hasContent).toList();

  @override
  List<Object> get props => [species];
}

final class SpeciesListError extends SpeciesListState {
  final String message;
  const SpeciesListError(this.message);

  @override
  List<Object> get props => [message];
}
