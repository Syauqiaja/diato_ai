import 'package:diato_ai/core/theme/theme.dart';
import 'package:diato_ai/features/shared/widgets/spacings.dart';
import 'package:diato_ai/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'widgets/info_section.dart';

class DeveloperInfoScreen extends StatelessWidget {
  static const String routeName = 'developer-info';
  static const String routePath = 'developer-info';

  const DeveloperInfoScreen({super.key});

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
          'Informasi Pengembang',
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
              InfoSection(
                label: null,
                content: _content
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const String _content = 
"""Diatom-AI dikembangkan oleh tim akademisi bidang pendidikan biologi dan ekologi perairan dari Universitas Negeri Malang. 
Tim pengembang terdiri dari

Pengembang utama : 
- M. Iqbal Najib Fahmi, M.Pd,

Pembimbing akademik dan peneliti:
- Prof. Dr. Susriyati Mahanal, 
- M.Pd, Prof. Dr. Siti Zubaidah, M.Pd, 
- Prof. Dr. Ibrohim, M.Si.

Pengembangan aplikasi ini didasarkan pada penelitian tentang komunitas diatom Sungai Brantas serta integrasi teknologi kecerdasan buatan untuk mendukung pembelajaran, penelitian, dan pemantauan kualitas perairan berbasis bioindikator.""";