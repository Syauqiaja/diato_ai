import 'package:diato_ai/core/data/result.dart';
import 'package:diato_ai/features/shared/models/station.dart';
import 'package:diato_ai/features/shared/models/station_detail.dart';

abstract class StationRepository {
  Future<Result<List<Station>>> getStations();
  Future<Result<StationDetail>> getStationDetail(int stationId);
}
