import 'package:diato_ai/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

import '../../domain/brdi_calculator.dart';
import 'brdi_category_style.dart';

/// Each species' share of the index's numerator, largest first.
class BrdiContributionBars extends StatelessWidget {
  final BrdiResult result;

  const BrdiContributionBars({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final total = result.totalScore;
    final contributions = [...result.contributions]
      ..sort((a, b) => b.score.compareTo(a.score));
    final category = result.category!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final contribution in contributions)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        contribution.species.name,
                        style: context.textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: category.foreground,
                        ),
                      ),
                    ),
                    Text(
                      '${contribution.count} · skor ${contribution.sensitivity}',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: category.foreground,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: total > 0 ? contribution.score / total : 0,
                    minHeight: 6,
                    backgroundColor: Colors.black.withValues(alpha: 0.06),
                    valueColor: AlwaysStoppedAnimation(category.color),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
