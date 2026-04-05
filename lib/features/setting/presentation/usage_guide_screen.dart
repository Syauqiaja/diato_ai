import 'package:diato_ai/core/theme/theme.dart';
import 'package:diato_ai/features/setting/presentation/widgets/info_section.dart';
import 'package:diato_ai/features/shared/widgets/spacings.dart';
import 'package:diato_ai/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'data/models/accordion_data.dart';

class UsageGuideScreen extends StatelessWidget {
  static const String routeName = 'usage-guide';
  static const String routePath = 'usage-guide';

  const UsageGuideScreen({super.key});

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
          'Petunjuk Penggunaan',
          style: context.textTheme.titleLarge?.copyWith(color: context.colorScheme.primary, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final section in _accordionSections) ...[InfoAccordionItem(title: section.title, content: section.content, initiallyExpanded: true,), vSpace(12)],
            ],
          ),
        ),
      ),
    );
  }
}

const List<AccordionData> _accordionSections = [AccordionData(title: '1.	Unduh dan instal aplikasi', content: 'Cari Diatom-AI di App Store atau Play Store, kemudian unduh dan instal aplikasi pada perangkat Anda.'), AccordionData(title: '2.	Pelajari dasar diatom', content: 'Buka menu Tentang Diatom untuk memahami karakteristik morfologi dan klasifikasi diatom sebelum melakukan identifikasi.'), AccordionData(title: '3.	Siapkan citra mikroskopis', content: 'Ambil foto diatom menggunakan mikroskop atau unggah citra yang telah tersedia.'), AccordionData(title: '4.	Lakukan identifikasi otomatis', content: 'Masuk ke fitur Identifikasi Diatom, unggah citra, lalu sistem AI-CNN akan mengenali spesies diatom secara otomatis.'), AccordionData(title: '5.	Analisis kualitas air', content: 'Gunakan fitur Indeks Diatom (BRDI) untuk menghitung kualitas air berdasarkan komposisi komunitas diatom yang ditemukan.'), AccordionData(title: '6.	Eksplorasi data penelitian', content: 'Buka menu Peta Distribusi Diatom untuk melihat persebaran spesies dan kondisi lingkungan di Sungai Brantas.')];
