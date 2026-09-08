import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/species_detail.dart';
import '../../domain/repositories/species_repository.dart';

part 'species_detail_state.dart';

class SpeciesDetailCubit extends Cubit<SpeciesDetailState> {
  final SpeciesRepository speciesRepository;

  SpeciesDetailCubit(this.speciesRepository) : super(SpeciesDetailInitial());

  Future<void> fetchSpeciesDetail(int speciesId) async {
    emit(SpeciesDetailLoading());
    final result = await speciesRepository.getSpeciesDetail(speciesId);

    result.when(
      success: (detail) => emit(SpeciesDetailData(detail)),
      failure: (message) => emit(SpeciesDetailError(message)),
    );
  }
}
