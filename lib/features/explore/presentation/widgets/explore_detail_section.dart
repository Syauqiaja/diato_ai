import 'package:diato_ai/core/assets/assets.dart';
import 'package:diato_ai/features/shared/widgets/linear_line.dart';
import 'package:diato_ai/features/shared/widgets/spacings.dart';
import 'package:diato_ai/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';

class ExploreDetailSection extends StatefulWidget {
  const ExploreDetailSection({super.key});

  @override
  State<ExploreDetailSection> createState() => _ExploreDetailSectionState();
}

class _ExploreDetailSectionState extends State<ExploreDetailSection> {
  @override
  Widget build(BuildContext context) {
    final textColor = context.colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.canvasColor,
        borderRadius: BorderRadius.circular(32),
      ),
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Tentang",
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: textColor,
                      ),
                    ),
                    Text(
                      "Diatom",
                      style: context.textTheme.displayLarge?.copyWith(
                        color: textColor,
                        height: 0.9,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  color: textColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  "1",
                  style: context.textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          vSpace(16),
          LinearLine(),
          vSpace(24),
          Container(
            height: 200,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            clipBehavior: Clip.hardEdge,
            child: Image.asset(
              Assets.diatomi,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          vSpace(24),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "Diatomi adalah",
                  style: context.textTheme.titleMedium?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text:
                      " suatu kelompok besar dari alga plankton yang termasuk paling sering ditemui.Kebanyakan diatom adalah bersel tunggal, walaupun beberapa membentuk rantai atau koloni.",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
