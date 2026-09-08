part of 'species_detail_cubit.dart';

sealed class SpeciesDetailState extends Equatable {
  const SpeciesDetailState();

  @override
  List<Object> get props => [];
}

final class SpeciesDetailInitial extends SpeciesDetailState {}

final class SpeciesDetailLoading extends SpeciesDetailState {}

final class SpeciesDetailData extends SpeciesDetailState {
  final SpeciesDetail speciesDetail;
  const SpeciesDetailData(this.speciesDetail);

  @override
  List<Object> get props => [speciesDetail];
}

final class SpeciesDetailError extends SpeciesDetailState {
  final String message;
  const SpeciesDetailError(this.message);

  @override
  List<Object> get props => [message];
}
