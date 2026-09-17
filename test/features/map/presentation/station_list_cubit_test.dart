import 'package:diato_ai/core/data/result.dart';
import 'package:diato_ai/features/map/domain/repositories/station_repository.dart';
import 'package:diato_ai/features/map/presentation/cubit/station_list_cubit.dart';
import 'package:diato_ai/features/shared/models/station.dart';
import 'package:diato_ai/features/shared/models/station_detail.dart';
import 'package:flutter_test/flutter_test.dart';

Station _station(int id, List<int> years) {
  return Station(
    id: id,
    title: 'Stasiun $id',
    description: '',
    latitude: 0,
    longitude: 0,
    image: null,
    speciesCount: 0,
    years: years,
  );
}

class _FakeRepository extends StationRepository {
  List<Station> stations = [
    _station(1, [1998, 2023]),
    _station(2, [2008]),
  ];

  @override
  Future<Result<List<Station>>> getStations() async => Result.success(stations);

  @override
  Future<Result<StationDetail>> getStationDetail(int stationId) async => Result.failure('unused');
}

void main() {
  test('lists every year and filters stations by the picked one', () async {
    final cubit = StationListCubit(_FakeRepository());
    await cubit.getStations();

    var state = cubit.state as StationListLoaded;
    expect(state.years, [1998, 2008, 2023]);
    expect(state.visibleStations, hasLength(2));

    cubit.selectYear(2008);
    state = cubit.state as StationListLoaded;
    expect(state.visibleStations.map((station) => station.id), [2]);

    cubit.selectYear(null);
    expect((cubit.state as StationListLoaded).visibleStations, hasLength(2));
  });

  test('a refresh keeps the picked year only while it still exists', () async {
    final repository = _FakeRepository();
    final cubit = StationListCubit(repository);
    await cubit.getStations();

    cubit.selectYear(2023);
    await cubit.getStations();
    expect((cubit.state as StationListLoaded).selectedYear, 2023);

    repository.stations = [_station(2, [2008])];
    await cubit.getStations();
    expect((cubit.state as StationListLoaded).selectedYear, isNull);
  });
}
