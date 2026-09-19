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

  const StationListLoaded(this.stations);

  @override
  List<Object> get props => [stations];
}

final class StationListError extends StationListState {
  final String message;

  const StationListError(this.message);

  @override
  List<Object> get props => [message];
}
