import 'package:bloc/bloc.dart';
import 'package:diato_ai/core/data/result.dart';
import 'package:diato_ai/features/map/domain/repositories/station_repository.dart';
import 'package:diato_ai/features/shared/models/station.dart';
import 'package:equatable/equatable.dart';

part 'station_list_state.dart';

class StationListCubit extends Cubit<StationListState> {
  final StationRepository _stationRepository;

  StationListCubit(this._stationRepository) : super(StationListInitial());

  /// Fetch all stations to plot on the map
  Future<void> getStations() async {
    emit(StationListLoading());

    try {
      final result = await _stationRepository.getStations();

      switch (result) {
        case Success<List<Station>>():
          emit(StationListLoaded(result.value));
        case Failure<List<Station>>():
          emit(StationListError(result.message));
      }
    } catch (e) {
      emit(StationListError('An unexpected error occurred: $e'));
    }
  }
}
