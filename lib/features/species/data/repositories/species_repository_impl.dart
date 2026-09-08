import 'package:diato_ai/core/data/result.dart';
import 'package:dio/dio.dart';

import '../../domain/repositories/species_repository.dart';
import '../models/species_detail.dart';
import '../models/species_summary.dart';

final class SpeciesRepositoryImpl extends SpeciesRepository {
  final Dio dio;

  SpeciesRepositoryImpl(this.dio);

  @override
  Future<Result<List<SpeciesSummary>>> getSpecies({String? query}) async {
    try {
      final response = await dio.get(
        '/species-catalogue',
        queryParameters: query != null ? {'q': query} : null,
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List<dynamic>;
        return Result.success(
          data
              .map((json) => SpeciesSummary.fromJson(json as Map<String, dynamic>))
              .toList(),
        );
      }
      return Result.failure(
        response.data['message'] ?? 'Gagal memuat daftar spesies',
      );
    } on DioException catch (e) {
      return Result.failure(_messageFor(e, 'Gagal memuat daftar spesies'));
    } catch (e) {
      return Result.failure('Unexpected error: $e');
    }
  }

  @override
  Future<Result<SpeciesDetail>> getSpeciesDetail(int speciesId) async {
    try {
      final response = await dio.get('/species-catalogue/$speciesId');

      if (response.statusCode == 200) {
        return Result.success(
          SpeciesDetail.fromJson(response.data['data'] as Map<String, dynamic>),
        );
      }
      return Result.failure(
        response.data['message'] ?? 'Gagal memuat penjelasan spesies',
      );
    } on DioException catch (e) {
      return Result.failure(_messageFor(e, 'Gagal memuat penjelasan spesies'));
    } catch (e) {
      return Result.failure('Unexpected error: $e');
    }
  }

  String _messageFor(DioException e, String fallback) {
    final data = e.response?.data;
    if (data is Map && data['message'] is String) {
      return data['message'] as String;
    }
    if (e.response != null) return fallback;
    return 'Network error: ${e.message}';
  }
}
