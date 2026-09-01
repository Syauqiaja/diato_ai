import 'package:bloc/bloc.dart';
import 'package:diato_ai/core/data/result.dart';
import 'package:diato_ai/features/map/domain/repositories/station_repository.dart';
import 'package:diato_ai/features/shared/models/station_detail.dart';
import 'package:equatable/equatable.dart';

part 'station_detail_state.dart';

class StationDetailCubit extends Cubit<StationDetailState> {
  final StationRepository _stationRepository;

  StationDetailCubit(this._stationRepository) : super(StationDetailInitial());

  /// Fetch a single station with its found species
  Future<void> getStationDetail(int stationId) async {
    emit(StationDetailLoading());

    try {
      final result = await _stationRepository.getStationDetail(stationId);

      switch (result) {
        case Success<StationDetail>():
          emit(StationDetailLoaded(result.value));
        case Failure<StationDetail>():
          emit(StationDetailError(result.message));
      }
    } catch (e) {
      emit(StationDetailError('An unexpected error occurred: $e'));
    }
  }
}
