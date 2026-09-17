part of 'station_list_cubit.dart';

sealed class StationListState extends Equatable {
  const StationListState();

  @override
  List<Object> get props => [];
}

final class StationListInitial extends StationListState {}

final class StationListLoading extends StationListState {}

final class StationListLoaded extends StationListState {
  final List<Station> stations;

  /// Year the map is filtered to; null shows every station.
  final int? selectedYear;

  const StationListLoaded(this.stations, {this.selectedYear});

  /// Every sampling year recorded at any station, oldest first.
  List<int> get years => (stations.expand((station) => station.years).toSet().toList()..sort());

  /// Stations with species records in [selectedYear].
  List<Station> get visibleStations {
    final year = selectedYear;
    if (year == null) return stations;
    return stations.where((station) => station.years.contains(year)).toList();
  }

  @override
  List<Object> get props => [stations, selectedYear ?? 0];
}

final class StationListError extends StationListState {
  final String message;

  const StationListError(this.message);

  @override
  List<Object> get props => [message];
}
