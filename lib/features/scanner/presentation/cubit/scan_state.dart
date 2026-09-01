part of 'scan_cubit.dart';

sealed class ScanState extends Equatable {
  const ScanState();

  /// Local path of the captured photo, kept across states so the UI can show
  /// the image while uploading and offer a retry after a failure.
  String? get imagePath => null;

  @override
  List<Object?> get props => [];
}

final class ScanInitial extends ScanState {}

final class ScanUploading extends ScanState {
  final String path;

  const ScanUploading(this.path);

  @override
  String? get imagePath => path;

  @override
  List<Object?> get props => [path];
}

final class ScanLoaded extends ScanState {
  final ScanResponse scan;
  final String path;

  const ScanLoaded(this.scan, this.path);

  @override
  String? get imagePath => path;

  @override
  List<Object?> get props => [scan.id, path];
}

final class ScanError extends ScanState {
  final String message;
  final String path;

  const ScanError(this.message, this.path);

  @override
  String? get imagePath => path;

  @override
  List<Object?> get props => [message, path];
}
