import 'package:diato_ai/features/home/presentation/widgets/home_body_list_section.dart';
import 'package:diato_ai/features/shared/widgets/spacings.dart';
import 'package:diato_ai/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class HomeBodySection extends StatefulWidget {
  const HomeBodySection({super.key});

  @override
  State<HomeBodySection> createState() => _HomeBodySectionState();
}

class _HomeBodySectionState extends State<HomeBodySection> {
  final EdgeInsetsGeometry _sectionPadding = const EdgeInsets.symmetric(
    horizontal: 16,
  );

  late YoutubePlayerController _youtubeController;

  @override
  void initState() {
    super.initState();
    _youtubeController = YoutubePlayerController.fromVideoId(
      videoId: 'Ygty9HxhFK4',
      autoPlay: false,
      params: const YoutubePlayerParams(
        showControls: true,
        mute: false,
        showFullscreenButton: true,
        loop: false,
        origin: 'https://www.youtube-nocookie.com',
      ),
    );
    // Seek to 3:36 after controller is ready
    _youtubeController.seekTo(seconds: 216);
  }

  @override
  void dispose() {
    _youtubeController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(
          color: context.theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              vSpace(24),
              _buildVideoSection(context),
              vSpace(24),
              _buildInfoSection(context),
              vSpace(24),
              _buildListHeader(context),
              vSpace(16),
              HomeBodyListSection(),
              vSpace(200),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoSection(BuildContext context) {
    return Padding(
      padding: _sectionPadding,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: YoutubePlayer(
          controller: _youtubeController,
          aspectRatio: 16 / 9,
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Padding(
      padding: _sectionPadding,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: context.colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: context.colorScheme.primary.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: context.colorScheme.primary,
                  size: 24,
                ),
                hSpace(8),
                Text(
                  "Tahukah kamu?",
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colorScheme.primary,
                  ),
                ),
              ],
            ),
            vSpace(12),
            Text(
              "Diatom punya peran besar dalam hidup kita.",
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            vSpace(8),
            Text(
              "Diatom dimanfaatkan dalam pembuatan pasta gigi, insektisida organik, suplemen kesehatan, dan bioindikator, serta berkontribusi besar terhadap oksigen yang kita hirup setiap hari.",
              style: context.textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListHeader(BuildContext context) {
    return Padding(
      padding: _sectionPadding,
      child: Row(
        children: [
          Expanded(
            child: Text(
              "Berita terbaru tentang Diatom",
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          hSpace(24),
          // TextButton(
          //   onPressed: () {},
          //   child: Text(
          //     "See more >",
          //     style: context.textTheme.titleMedium?.copyWith(
          //       fontWeight: FontWeight.bold,
          //       color: context.colorScheme.primary,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
