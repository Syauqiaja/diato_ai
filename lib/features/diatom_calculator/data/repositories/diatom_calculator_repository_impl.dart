import 'package:diato_ai/core/data/result.dart';
import 'package:dio/dio.dart';

import '../../domain/brdi_calculator.dart';
import '../../domain/repositories/diatom_calculator_repository.dart';
import '../models/catalogue_species.dart';
import '../models/saved_calculation.dart';

final class DiatomCalculatorRepositoryImpl extends DiatomCalculatorRepository {
  final Dio dio;

  DiatomCalculatorRepositoryImpl(this.dio);

  @override
  Future<Result<List<CatalogueSpecies>>> getCatalogue() async {
    try {
      final response = await dio.get('/species-catalogue');

      if (response.statusCode == 200) {
        final data = response.data['data'] as List<dynamic>;
        final species = data
            .map(
              (json) => CatalogueSpecies.fromJson(json as Map<String, dynamic>),
            )
            .toList();
        return Result.success(species);
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
  Future<Result<List<SavedCalculation>>> getSavedCalculations() async {
    try {
      final response = await dio.get('/brdi-calculations');

      if (response.statusCode == 200) {
        final data = response.data['data'] as List<dynamic>;
        final calculations = data
            .map(
              (json) => SavedCalculation.fromJson(json as Map<String, dynamic>),
            )
            .toList();
        return Result.success(calculations);
      }
      return Result.failure(
        response.data['message'] ?? 'Gagal memuat riwayat perhitungan',
      );
    } on DioException catch (e) {
      return Result.failure(_messageFor(e, 'Gagal memuat riwayat perhitungan'));
    } catch (e) {
      return Result.failure('Unexpected error: $e');
    }
  }

  @override
  Future<Result<SavedCalculation>> saveCalculation({
    required String? location,
    required BrdiResult result,
    required List<SpeciesEntry> entries,
  }) async {
    final di = result.di;
    final category = result.category;
    if (di == null || category == null) {
      return Result.failure('Belum ada indeks yang bisa disimpan');
    }

    try {
      // Every counted species is sent, scored or not, so the reading records
      // the whole sample rather than only the part that moved the index. The
      // scores travel with it as a snapshot of the catalogue at save time.
      final response = await dio.post(
        '/brdi-calculations',
        data: {
          'location': location,
          'di': double.parse(di.toStringAsFixed(2)),
          'category': category.value,
          'entries': entries
              .map(
                (entry) => {
                  'species_id': entry.species.id,
                  'species_name': entry.species.name,
                  'count': entry.count,
                  'sensitivity': entry.species.sensitivity,
                  'indicator': entry.species.indicator,
                },
              )
              .toList(),
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return Result.success(
          SavedCalculation.fromJson(
            response.data['data'] as Map<String, dynamic>,
          ),
        );
      }
      return Result.failure(
        response.data['message'] ?? 'Gagal menyimpan perhitungan',
      );
    } on DioException catch (e) {
      return Result.failure(_messageFor(e, 'Gagal menyimpan perhitungan'));
    } catch (e) {
      return Result.failure('Unexpected error: $e');
    }
  }

  @override
  Future<Result<void>> deleteCalculation(int id) async {
    try {
      final response = await dio.delete('/brdi-calculations/$id');

      if (response.statusCode == 200) {
        return Result.success(null);
      }
      return Result.failure(
        response.data['message'] ?? 'Gagal menghapus perhitungan',
      );
    } on DioException catch (e) {
      return Result.failure(_messageFor(e, 'Gagal menghapus perhitungan'));
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
