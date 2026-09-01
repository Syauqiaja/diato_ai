import 'package:bloc/bloc.dart';
import 'package:diato_ai/core/data/result.dart';
import 'package:diato_ai/features/scanner/data/models/scan_response.dart';
import 'package:diato_ai/features/scanner/domain/repositories/scanner_repository.dart';
import 'package:equatable/equatable.dart';

part 'scan_state.dart';

class ScanCubit extends Cubit<ScanState> {
  final ScannerRepository _scannerRepository;

  ScanCubit(this._scannerRepository) : super(ScanInitial());

  /// Upload [imagePath] and identify the diatom in it.
  Future<void> identify(String imagePath) async {
    emit(ScanUploading(imagePath));

    try {
      final result = await _scannerRepository.identify(imagePath);

      switch (result) {
        case Success<ScanResponse>():
          emit(ScanLoaded(result.value, imagePath));
        case Failure<ScanResponse>():
          emit(ScanError(result.message, imagePath));
      }
    } catch (e) {
      emit(ScanError('Terjadi kesalahan tak terduga: $e', imagePath));
    }
  }

  /// Re-run identification on the image from the last attempt.
  Future<void> retry() async {
    final path = state.imagePath;
    if (path != null) {
      await identify(path);
    }
  }
}
