import 'package:diato_ai/core/assets/assets.dart';
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
              vSpace(16),
              _DeveloperTeamSection(developers: _developers),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeveloperTeamSection extends StatelessWidget {
  final List<_DeveloperData> developers;

  const _DeveloperTeamSection({required this.developers});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.canvasColor,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Tim Pengembang',
              style: context.textTheme.titleMedium?.copyWith(
                color: context.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            vSpace(12),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                mainAxisExtent: 280,
              ),
              itemCount: developers.length,
              itemBuilder: (context, index) {
                final developer = developers[index];
                return _DeveloperCard(developer: developer);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DeveloperCard extends StatelessWidget {
  final _DeveloperData developer;

  const _DeveloperCard({required this.developer});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: AspectRatio(
            aspectRatio: 3 / 4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                developer.imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        vSpace(8),
        Text(
          developer.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _DeveloperData {
  final String name;
  final String imagePath;

  const _DeveloperData({
    required this.name,
    required this.imagePath,
  });
}

const List<_DeveloperData> _developers = [
  _DeveloperData(
    name: 'M. Iqbal Najib Fahmi, M.Pd',
    imagePath: Assets.imgFahmi,
  ),
  _DeveloperData(
    name: 'Prof. Dr. Susriyati Mahanal, M.Pd',
    imagePath: Assets.imgSusriyati,
  ),
  _DeveloperData(
    name: 'Prof. Dr. Siti Zubaidah, M.Pd',
    imagePath: Assets.imgZubaidah,
  ),
  _DeveloperData(
    name: 'Prof. Dr. Ibrohim, M.Si',
    imagePath: Assets.imgIbrohim,
  ),
];

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