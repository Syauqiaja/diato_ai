import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/species_summary.dart';
import '../../domain/repositories/species_repository.dart';

part 'species_list_state.dart';

class SpeciesListCubit extends Cubit<SpeciesListState> {
  final SpeciesRepository speciesRepository;

  SpeciesListCubit(this.speciesRepository) : super(SpeciesListInitial());

  Future<void> fetchSpecies() async {
    emit(SpeciesListLoading());
    final result = await speciesRepository.getSpecies();

    result.when(
      success: (species) => emit(SpeciesListData(species)),
      failure: (message) => emit(SpeciesListError(message)),
    );
  }
}
