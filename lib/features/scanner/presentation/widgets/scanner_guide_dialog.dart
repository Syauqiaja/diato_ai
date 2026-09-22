import 'package:diato_ai/features/shared/actionable/app_button.dart';
import 'package:diato_ai/features/shared/widgets/spacings.dart';
import 'package:diato_ai/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Explains how to get a usable diatom photo out of the scanner.
class ScannerGuideDialog extends StatelessWidget {
  const ScannerGuideDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (_) => const ScannerGuideDialog(),
    );
  }

  static const List<_GuideStep> _steps = [
    _GuideStep(
      icon: FontAwesomeIcons.microscope,
      title: 'Siapkan sampel',
      body: 'Letakkan preparat diatom di mikroskop dan atur fokus hingga '
          'bentuk dan pola cangkangnya terlihat tajam.',
    ),
    _GuideStep(
      icon: FontAwesomeIcons.crosshairs,
      title: 'Arahkan kamera',
      body: 'Tempelkan kamera ke lensa okuler dan posisikan satu diatom '
          'di tengah bingkai. Tahan ponsel tetap stabil.',
    ),
    _GuideStep(
      icon: FontAwesomeIcons.boltLightning,
      title: 'Atur pencahayaan',
      body: 'Pastikan cahaya cukup dan merata. Nyalakan Flash bila '
          'gambar terlihat terlalu gelap.',
    ),
    _GuideStep(
      icon: FontAwesomeIcons.camera,
      title: 'Ambil atau pilih foto',
      body: 'Tekan tombol kamera untuk memotret, atau pilih foto mikroskop '
          'yang sudah ada dari Galeri.',
    ),
    _GuideStep(
      icon: FontAwesomeIcons.wandMagicSparkles,
      title: 'Lihat hasil',
      body: 'Model akan menganalisis gambar dan menampilkan kandidat genus '
          'beserta tingkat kecocokannya.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: primary,
            padding: const EdgeInsets.fromLTRB(24, 24, 12, 24),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: context.colorScheme.tertiary,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: FaIcon(FontAwesomeIcons.lightbulb,
                      size: 20, color: primary),
                ),
                hSpace(14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Panduan Scan',
                        style: context.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Tips agar diatom mudah dikenali',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: Colors.white),
                  tooltip: 'Tutup',
                ),
              ],
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
              child: Column(
                children: [
                  for (var i = 0; i < _steps.length; i++)
                    _StepTile(
                      number: i + 1,
                      step: _steps[i],
                      isLast: i == _steps.length - 1,
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: AppButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Mengerti'),
            ),
          ),
        ],
      ),
    );
  }
}

class _GuideStep {
  final IconData icon;
  final String title;
  final String body;

  const _GuideStep({required this.icon, required this.title, required this.body});
}

class _StepTile extends StatelessWidget {
  final int number;
  final _GuideStep step;
  final bool isLast;

  const _StepTile({
    required this.number,
    required this.step,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$number',
                  style: context.textTheme.labelLarge?.copyWith(
                    color: primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: primary.withValues(alpha: 0.15),
                  ),
                ),
            ],
          ),
          hSpace(14),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 8 : 20, top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      FaIcon(step.icon, size: 14, color: primary),
                      hSpace(8),
                      Expanded(
                        child: Text(
                          step.title,
                          style: context.textTheme.titleSmall?.copyWith(
                            color: primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  vSpace(4),
                  Text(
                    step.body,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
