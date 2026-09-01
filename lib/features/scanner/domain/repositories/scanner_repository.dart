import 'package:diato_ai/core/data/result.dart';
import 'package:diato_ai/features/scanner/data/models/scan_response.dart';

abstract class ScannerRepository {
  /// Upload a photo and identify the diatom in it.
  Future<Result<ScanResponse>> identify(String imagePath);

  /// The signed-in user's previous scans, newest first.
  Future<Result<List<ScanResponse>>> history();
}
