import 'package:diato_ai/core/data/result.dart';
import 'package:diato_ai/features/map/domain/repositories/station_repository.dart';
import 'package:diato_ai/features/shared/models/station.dart';
import 'package:diato_ai/features/shared/models/station_detail.dart';
import 'package:dio/dio.dart';

final class StationRepositoryImpl extends StationRepository {
  final Dio dio;

  StationRepositoryImpl(this.dio);

  @override
  Future<Result<List<Station>>> getStations() async {
    try {
      final response = await dio.get('/stations');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] as List<dynamic>;
        final stations = data.map((json) => Station.fromJson(json as Map<String, dynamic>)).toList();
        return Result.success(stations);
      } else {
        return Result.failure(response.data['message'] ?? 'Failed to fetch stations');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final message = e.response?.data['message'];
        return Result.failure(message ?? 'An error occurred');
      } else {
        return Result.failure('Network error: ${e.message}');
      }
    } catch (e) {
      return Result.failure('Unexpected error: $e');
    }
  }

  @override
  Future<Result<StationDetail>> getStationDetail(int stationId) async {
    try {
      final response = await dio.get('/stations/$stationId');

      if (response.statusCode == 200) {
        final stationDetail = StationDetail.fromJson(response.data['data'] as Map<String, dynamic>);
        return Result.success(stationDetail);
      } else {
        return Result.failure(response.data['message'] ?? 'Failed to fetch station detail');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final message = e.response?.data['message'];
        return Result.failure(message ?? 'An error occurred');
      } else {
        return Result.failure('Network error: ${e.message}');
      }
    } catch (e) {
      return Result.failure('Unexpected error: $e');
    }
  }
}
