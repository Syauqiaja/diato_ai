import 'package:diato_ai/core/theme/theme.dart';
import 'package:diato_ai/features/shared/widgets/spacings.dart';
import 'package:diato_ai/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'widgets/info_section.dart';

class AppInfoScreen extends StatelessWidget {
  static const String routeName = 'app-info';
  static const String routePath = 'app-info';

  AppInfoScreen({super.key});

  static void push(BuildContext context) {
    context.pushNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.secondaryCanvasColor,
      appBar: AppBar(
        backgroundColor: AppTheme.secondaryCanvasColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.colorScheme.primary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Informasi Tentang Aplikasi',
          style: context.textTheme.titleLarge?.copyWith(color: context.colorScheme.primary, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InfoSection(
                label: 'Last Updated',
                content: 'April 2026',
              ),
              vSpace(16),
              for (var content in _contents)
                InfoSection(
                  label: null,
                  content: content,
                ),
              vSpace(16),
              for (final entry in _accordionContents.entries) ...[
                InfoAccordionItem(
                  title: entry.key,
                  content: entry.value,
                ),
                vSpace(12),
              ],
            ],
          ),
        ),
      ),
    );
  }


  final List<String> _contents = [
"""Diatom-AI merupakan aplikasi berbasis Convolutional Neural Networks (AI-CNN) yang dikembangkan untuk mendukung pembelajaran dan penelitian diatom dalam kerangka Generative Pedagogy–Microalgae Identification Learning. Aplikasi ini memfasilitasi tahapan Constructing, Investigating, dan Interpreting dalam proses pembelajaran.

Pada tahap Constructing, Diatom-AI menyediakan informasi dasar tentang diatom. Pada tahap Investigating, aplikasi mendukung identifikasi spesies diatom secara otomatis berbasis AI-CNN. Selanjutnya, pada tahap Interpreting, aplikasi membantu pengguna mengaitkan hasil identifikasi dengan kondisi ekologis perairan melalui perhitungan indeks kualitas air menggunakan Brantas River Diatom Index (BRDI).""",
  ];
  final Map<String, String> _accordionContents = {
    "Capaian Pembelajaran Lulusan" : "Penggunaan Diatom-AI mendukung Capaian Pembelajaran Lulusan (CPL), yaitu mahasiswa menguasai konsep teoritis biologi dasar secara terintegrasi dengan menggunakan pemikiran logis, kritis, sistematis dan inovatif melalui pendekatan IPTEK untuk menganalisis  berbagai permasalahan dibidang biologi sehingga dapat mengagumi dan berusaha menjaga ciptaanNya.",
    "Capaian Pembelajaran Mata Kuliah" : "Pemanfaatan Diatom-AI mendukung Capaian Pembelajaran Mata Kuliah (CPMK) Protista poin 1, yaitu mahasiswa menguasai konsep tentang struktur morfologi, fisiologi,  reproduksi,  sistematika, dan peranan organisme kelompok Protista mirip tumbuhan.",
    "Sub- Capaian Pembelajaran Mata Kuliah" : 
"""Pemanfaatan Diatom-AI mendukung pencapaian Sub-CPMK
1.1 Menjelaskan karakteristik Protista mirip tumbuhan, mengklasifikasikan Protista mirip tumbuhan.
1.2 Menjelaskan karakteristik dan kehidupan Protista mirip tumbuhan: Chlorophyta

Materi esensial yang didukung melalui aplikasi ini meliputi karakteristik dan struktur diatom perifiton, fisiologi, reproduksi, dan siklus hidupnya, metode pencuplikan dan identifikasi spesies, serta keterkaitan komunitas diatom perifiton dengan parameter lingkungan perairan."""
  };
}
