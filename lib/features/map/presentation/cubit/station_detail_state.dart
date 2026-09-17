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

  /// Year the species list is filtered to; null shows every year.
  final int? selectedYear;

  const StationDetailLoaded(this.station, {this.selectedYear});

  @override
  List<Object> get props => [station.id, selectedYear ?? 0];
}

final class StationDetailError extends StationDetailState {
  final String message;

  const StationDetailError(this.message);

  @override
  List<Object> get props => [message];
}
