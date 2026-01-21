import 'package:diato_ai/core/theme/theme.dart';
import 'package:diato_ai/features/scanner/data/models/detected_diatom.dart';
import 'package:diato_ai/features/scanner/presentation/widgets/detected_diatom_card.dart';
import 'package:diato_ai/features/shared/actionable/app_button.dart';
import 'package:diato_ai/features/shared/widgets/linear_line.dart';
import 'package:diato_ai/features/shared/widgets/spacings.dart';
import 'package:diato_ai/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class ScannerDetailScreen extends StatefulWidget {
  static const String routeName = 'scanner_detail';
  static const String routePath = '/scanner/detail';
  const ScannerDetailScreen({super.key});

  @override
  State<ScannerDetailScreen> createState() => _ScannerDetailScreenState();
}

class _ScannerDetailScreenState extends State<ScannerDetailScreen> {
  // Dummy data - multiple detected diatoms
  final List<DetectedDiatom> detectedDiatoms = [
    DetectedDiatom(
      species: 'Navicula sp.',
      type: 'Pennate',
      description: 'Common freshwater pennate diatom',
      confidence: 0.92,
      habitat: 'Perairan tawar, sungai, dan danau',
      size: '10-100 μm',
      shape: 'Navicular (seperti perahu)',
    ),
    DetectedDiatom(
      species: 'Pinnularia sp.',
      type: 'Pennate',
      description: 'Large pennate diatom with prominent raphe',
      confidence: 0.85,
      habitat: 'Perairan tawar oligotrofik',
      size: '50-300 μm',
      shape: 'Memanjang dengan ujung membulat',
    ),
    DetectedDiatom(
      species: 'Gomphonema sp.',
      type: 'Pennate',
      description: 'Wedge-shaped attached diatom',
      confidence: 0.78,
      habitat: 'Menempel pada substrat di aliran air',
      size: '20-80 μm',
      shape: 'Berbentuk baji asimetris',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.canvasColor,
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            color: AppTheme.canvasColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: AppButton(onPressed: () {}, child: const Text("Simpan")),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Scan",
                          style: context.textTheme.titleMedium?.copyWith(),
                        ),
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
                  ),
                ],
              ),
              vSpace(32),
              Expanded(
                child: SingleChildScrollView(
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: context.colorScheme.primary.withOpacity(
                                0.1,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              '${detectedDiatoms.length} diatom terdeteksi',
                              style: context.textTheme.bodySmall?.copyWith(
                                color: context.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      vSpace(16),
                      // Scanned image
                      Container(
                        height: 250,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.network(
                          'https://picsum.photos/seed/diatom-scan/800/600',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Icon(
                                Icons.image_not_supported,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                            );
                          },
                        ),
                      ),
                      vSpace(24),
                      // List of detected diatoms
                      ...detectedDiatoms.asMap().entries.map((entry) {
                        final index = entry.key;
                        final diatom = entry.value;
                        return Column(
                          children: [
                            if (index > 0) vSpace(12),
                            DetectedDiatomCard(
                              diatom: diatom,
                              number: index + 1,
                            ),
                          ],
                        );
                      }).toList(),
                      vSpace(16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
