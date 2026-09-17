import 'package:bloc/bloc.dart';
import 'package:diato_ai/core/data/result.dart';
import 'package:diato_ai/features/map/domain/repositories/station_repository.dart';
import 'package:diato_ai/features/shared/models/station_detail.dart';
import 'package:equatable/equatable.dart';

part 'station_detail_state.dart';

class StationDetailCubit extends Cubit<StationDetailState> {
  final StationRepository _stationRepository;

  StationDetailCubit(this._stationRepository) : super(StationDetailInitial());

  /// Fetch a single station with its found species, filtered to [year] when
  /// the station has records for it.
  Future<void> getStationDetail(int stationId, {int? year}) async {
    emit(StationDetailLoading());

    try {
      final result = await _stationRepository.getStationDetail(stationId);

      switch (result) {
        case Success<StationDetail>():
          emit(StationDetailLoaded(
            result.value,
            selectedYear: result.value.years.contains(year) ? year : null,
          ));
        case Failure<StationDetail>():
          emit(StationDetailError(result.message));
      }
    } catch (e) {
      emit(StationDetailError('An unexpected error occurred: $e'));
    }
  }

  /// Filter the loaded station's species to [year]; null shows every year.
  void selectYear(int? year) {
    final current = state;
    if (current is! StationDetailLoaded) return;

    emit(StationDetailLoaded(current.station, selectedYear: year));
  }
}
