import 'package:diato_ai/features/home/presentation/widgets/home_body_list_section.dart';
import 'package:diato_ai/features/shared/widgets/spacings.dart';
import 'package:diato_ai/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class HomeBodySection extends StatefulWidget {
  const HomeBodySection({super.key});

  @override
  State<HomeBodySection> createState() => _HomeBodySectionState();
}

class _HomeBodySectionState extends State<HomeBodySection> {
  final EdgeInsetsGeometry _sectionPadding = const EdgeInsets.symmetric(
    horizontal: 16,
  );

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

  Widget _buildListHeader(BuildContext context) {
    return Padding(
      padding: _sectionPadding,
      child: Row(
        children: [
          Expanded(
            child: Text(
              "Penelitian-Penelitian diatom di Sungai Brantas",
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          hSpace(24),
          TextButton(
            onPressed: () {},
            child: Text(
              "See more >",
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
