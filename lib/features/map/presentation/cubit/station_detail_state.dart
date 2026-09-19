part of 'station_detail_cubit.dart';

sealed class StationDetailState extends Equatable {
  const StationDetailState();

  @override
  List<Object> get props => [];
}

final class StationDetailInitial extends StationDetailState {}

final class StationDetailLoading extends StationDetailState {}

final class StationDetailLoaded extends StationDetailState {
  final StationDetail station;

  const StationDetailLoaded(this.station);

  @override
  List<Object> get props => [station.id];
}

final class StationDetailError extends StationDetailState {
  final String message;

  const StationDetailError(this.message);

  @override
  List<Object> get props => [message];
}
