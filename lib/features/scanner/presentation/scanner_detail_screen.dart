import 'dart:io';

import 'package:diato_ai/core/di/injection.dart';
import 'package:diato_ai/core/theme/theme.dart';
import 'package:diato_ai/features/scanner/data/models/scan_response.dart';
import 'package:diato_ai/features/scanner/presentation/cubit/scan_cubit.dart';
import 'package:diato_ai/features/scanner/presentation/widgets/detected_diatom_card.dart';
import 'package:diato_ai/features/shared/actionable/app_button.dart';
import 'package:diato_ai/features/shared/widgets/linear_line.dart';
import 'package:diato_ai/features/shared/widgets/spacings.dart';
import 'package:diato_ai/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ScannerDetailScreen extends StatelessWidget {
  static const String routeName = 'scanner_detail';
  static const String routePath = '/scanner/detail';

  /// Local file path of the photo captured or picked on the previous screen.
  final String? imagePath;

  const ScannerDetailScreen({super.key, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = ScanCubit(getIt());
        if (imagePath != null) {
          cubit.identify(imagePath!);
        }
        return cubit;
      },
      child: _ScannerDetailView(imagePath: imagePath),
    );
  }
}

class _ScannerDetailView extends StatelessWidget {
  final String? imagePath;

  const _ScannerDetailView({this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.canvasColor,
      bottomNavigationBar: _BottomBar(imagePath: imagePath),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("Scan", style: context.textTheme.titleMedium),
                  Text(
                    "Diatom",
                    style: context.textTheme.displayMedium?.copyWith(
                      color: context.colorScheme.primary,
                    ),
                  ),
                  vSpace(8),
                  const LinearLine(),
                ],
              ),
              vSpace(32),
              Expanded(
                child: BlocBuilder<ScanCubit, ScanState>(
                  builder: (context, state) => switch (state) {
                    ScanInitial() => const _NoImage(),
                    ScanUploading(:final path) => _Uploading(path: path),
                    ScanError(:final message, :final path) =>
                      _Error(message: message, path: path),
                    ScanLoaded(:final scan, :final path) =>
                      _Results(scan: scan, path: path),
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoImage extends StatelessWidget {
  const _NoImage();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_outlined, size: 64, color: Colors.grey[400]),
          vSpace(12),
          Text(
            'Tidak ada gambar untuk dianalisis.',
            style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

class _Uploading extends StatelessWidget {
  final String path;

  const _Uploading({required this.path});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _CapturedImage(path: path),
        vSpace(32),
        const CircularProgressIndicator(),
        vSpace(16),
        Text(
          'Menganalisis diatom...',
          style: context.textTheme.titleMedium?.copyWith(
            color: context.colorScheme.primary,
          ),
        ),
        vSpace(4),
        Text(
          'Model CNN sedang mengenali spesies pada gambar.',
          textAlign: TextAlign.center,
          style: context.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }
}

class _Error extends StatelessWidget {
  final String message;
  final String path;

  const _Error({required this.message, required this.path});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _CapturedImage(path: path),
          vSpace(24),
          Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
          vSpace(12),
          Text(
            'Gagal menganalisis',
            style: context.textTheme.titleMedium?.copyWith(color: Colors.red[700]),
          ),
          vSpace(6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: context.textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
          ),
          vSpace(20),
          AppButton(
            onPressed: () => context.read<ScanCubit>().retry(),
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }
}

class _Results extends StatelessWidget {
  final ScanResponse scan;
  final String path;

  const _Results({required this.scan, required this.path});

  @override
  Widget build(BuildContext context) {
    final results = scan.results;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Hasil Scan",
                style: context.textTheme.titleLarge?.copyWith(
                  color: context.colorScheme.primary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: context.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${results.length} kandidat',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          vSpace(16),
          _CapturedImage(path: path, remoteUrl: scan.imageUrl),
          vSpace(16),

          // The model thresholds its own output: below the cut-off it reports
          // "unknown" rather than a species. Surfacing that honestly matters
          // more than showing a confident-looking name.
          if (!scan.isConfident) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.4)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.help_outline, color: Colors.orange[800], size: 20),
                  hSpace(10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tidak ada kecocokan yang meyakinkan',
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.orange[900],
                          ),
                        ),
                        vSpace(4),
                        Text(
                          'Spesies ini mungkin belum ada dalam model, atau '
                          'gambarnya kurang jelas. Kandidat terdekat '
                          'ditampilkan di bawah sebagai perkiraan.',
                          style: context.textTheme.bodySmall?.copyWith(
                            color: Colors.orange[900],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            vSpace(16),
          ],

          if (results.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                children: [
                  Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
                  vSpace(12),
                  Text(
                    'Tidak ada diatom yang terdeteksi pada gambar ini.',
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyMedium
                        ?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          else
            ...results.asMap().entries.map(
                  (entry) => Column(
                    children: [
                      if (entry.key > 0) vSpace(12),
                      DetectedDiatomCard(
                        diatom: entry.value,
                        number: entry.key + 1,
                      ),
                    ],
                  ),
                ),

          if (scan.modelVersion != null) ...[
            vSpace(20),
            Text(
              'Model ${scan.modelVersion}'
              '${scan.inferenceMs != null ? ' · ${scan.inferenceMs} ms' : ''}',
              textAlign: TextAlign.center,
              style: context.textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
            ),
          ],
          vSpace(16),
        ],
      ),
    );
  }
}

class _CapturedImage extends StatelessWidget {
  final String path;
  final String? remoteUrl;

  const _CapturedImage({required this.path, this.remoteUrl});

  @override
  Widget build(BuildContext context) {
    // Prefer the local file: it is already on disk, so it renders instantly and
    // still works if the device drops offline after the upload.
    final file = File(path);

    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: file.existsSync()
          ? Image.file(file, fit: BoxFit.cover, width: double.infinity)
          : (remoteUrl != null
              ? Image.network(remoteUrl!, fit: BoxFit.cover, width: double.infinity)
              : Center(
                  child: Icon(Icons.image_not_supported,
                      size: 64, color: Colors.grey[400]),
                )),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final String? imagePath;

  const _BottomBar({this.imagePath});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          color: AppTheme.canvasColor,
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2)),
          ],
        ),
        child: BlocBuilder<ScanCubit, ScanState>(
          builder: (context, state) {
            final busy = state is ScanUploading;

            return Row(
              spacing: 8,
              children: [
                Expanded(
                  child: AppButton(
                    onPressed: busy ? null : () => context.pop(),
                    backgroundColor: AppButtonColorType.white,
                    foregroundColor: AppButtonColorType.primary,
                    child: const Text("Scan Lagi"),
                  ),
                ),
                Expanded(
                  child: AppButton(
                    // The scan is already persisted by POST /scans, so this
                    // just confirms and returns rather than saving again.
                    onPressed: state is ScanLoaded
                        ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Hasil scan tersimpan di Riwayat.'),
                              ),
                            );
                            context.pop();
                          }
                        : null,
                    child: const Text("Simpan"),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
