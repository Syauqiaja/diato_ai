import 'package:diato_ai/core/data/result.dart';
import 'package:diato_ai/features/scanner/data/models/scan_response.dart';
import 'package:diato_ai/features/scanner/domain/repositories/scanner_repository.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as p;

final class ScannerRepositoryImpl extends ScannerRepository {
  final Dio dio;

  ScannerRepositoryImpl(this.dio);

  @override
  Future<Result<ScanResponse>> identify(String imagePath) async {
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imagePath,
          filename: p.basename(imagePath),
          contentType: MediaType('image', _subtype(imagePath)),
        ),
      });

      final response = await dio.post(
        '/scans',
        data: formData,
        // Dio sets the multipart boundary itself; the client default of
        // application/json would make Laravel reject the upload.
        options: Options(contentType: 'multipart/form-data'),
      );

      final body = response.data as Map<String, dynamic>;
      final data = body['data'] as Map<String, dynamic>?;
      if (data == null) {
        return Result.failure(body['message'] ?? 'Gagal memproses hasil scan');
      }

      // The backend reports a below-threshold result with status true but a
      // different message. Carry that through so the UI can say "no confident
      // match" instead of presenting a shaky guess as fact.
      final confident = (body['message'] as String? ?? '')
          .toLowerCase()
          .startsWith('diatom identified');

      return Result.success(ScanResponse.fromJson(data, isConfident: confident));
    } on DioException catch (e) {
      return Result.failure(_message(e));
    } catch (e) {
      return Result.failure('Terjadi kesalahan tak terduga: $e');
    }
  }

  @override
  Future<Result<List<ScanResponse>>> history() async {
    try {
      final response = await dio.get('/scans');
      final data = response.data['data'] as List<dynamic>? ?? [];

      return Result.success(
        data
            .map((e) => ScanResponse.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } on DioException catch (e) {
      return Result.failure(_message(e));
    } catch (e) {
      return Result.failure('Terjadi kesalahan tak terduga: $e');
    }
  }

  /// The API only accepts jpeg/jpg/png. Gallery imports can arrive with other
  /// extensions (heic, webp), so anything unknown is declared as jpeg — the
  /// picker re-encodes to JPEG when it resizes.
  String _subtype(String path) {
    final ext = p.extension(path).toLowerCase().replaceFirst('.', '');
    return ext == 'png' ? 'png' : 'jpeg';
  }

  String _message(DioException e) {
    final response = e.response;
    if (response != null) {
      final data = response.data;
      final message = data is Map<String, dynamic> ? data['message'] as String? : null;

      return switch (response.statusCode) {
        401 => 'Sesi kamu sudah berakhir. Silakan masuk lagi.',
        // The Laravel controller answers 503 when the CNN service is down.
        503 => message ?? 'Layanan identifikasi sedang tidak tersedia.',
        422 => message ?? 'Gambar tidak valid. Gunakan foto JPG atau PNG.',
        _ => message ?? 'Terjadi kesalahan (${response.statusCode}).',
      };
    }

    return switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout =>
        'Koneksi timeout. Periksa jaringan kamu dan coba lagi.',
      DioExceptionType.connectionError =>
        'Tidak dapat terhubung ke server. Periksa koneksi internet.',
      _ => 'Kesalahan jaringan: ${e.message}',
    };
  }
}
