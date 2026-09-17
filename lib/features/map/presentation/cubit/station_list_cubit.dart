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
    final previousYear = switch (state) {
      StationListLoaded(:final selectedYear) => selectedYear,
      _ => null,
    };

    emit(StationListLoading());

    try {
      final result = await _stationRepository.getStations();

      switch (result) {
        case Success<List<Station>>():
          final years = result.value.expand((station) => station.years).toSet();
          emit(StationListLoaded(
            result.value,
            selectedYear: years.contains(previousYear) ? previousYear : null,
          ));
        case Failure<List<Station>>():
          emit(StationListError(result.message));
      }
    } catch (e) {
      emit(StationListError('An unexpected error occurred: $e'));
    }
  }

  /// Show only the stations with species records in [year]; null shows all.
  void selectYear(int? year) {
    final current = state;
    if (current is! StationListLoaded) return;

    emit(StationListLoaded(current.stations, selectedYear: year));
  }
}
