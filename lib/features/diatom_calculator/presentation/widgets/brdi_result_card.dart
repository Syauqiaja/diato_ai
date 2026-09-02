import 'package:diato_ai/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

import '../../domain/brdi_calculator.dart';
import 'brdi_category_badge.dart';
import 'brdi_category_style.dart';
import 'brdi_gauge.dart';

/// The index as it stands, with the per-species breakdown behind a disclosure.
class BrdiResultCard extends StatefulWidget {
  final BrdiResult result;

  const BrdiResultCard({super.key, required this.result});

  @override
  State<BrdiResultCard> createState() => _BrdiResultCardState();
}

class _BrdiResultCardState extends State<BrdiResultCard> {
  bool _showDetail = false;

  @override
  Widget build(BuildContext context) {
    final di = widget.result.di;
    final category = widget.result.category;

    if (di == null || category == null) {
      return _EmptyResult();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: category.background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Text(
              formatIndex(di),
              style: context.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: category.foreground,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Center(child: BrdiCategoryBadge(category: category)),
          const SizedBox(height: 16),
          BrdiGauge(di: di),
          const SizedBox(height: 12),
          Text(
            'Dihitung dari ${widget.result.contributions.length} spesies; '
            'yang belum punya skor dihitung sebagai 0.',
            style: context.textTheme.bodySmall?.copyWith(
              color: category.foreground,
            ),
          ),
          InkWell(
            onTap: () => setState(() => _showDetail = !_showDetail),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Detail kontribusi spesies',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: category.foreground,
                    ),
                  ),
                  Icon(
                    _showDetail ? Icons.expand_less : Icons.expand_more,
                    size: 20,
                    color: category.foreground,
                  ),
                ],
              ),
            ),
          ),
          if (_showDetail) _ContributionBars(result: widget.result),
        ],
      ),
    );
  }
}

/// Each species' share of the index's numerator, largest first.
class _ContributionBars extends StatelessWidget {
  final BrdiResult result;

  const _ContributionBars({required this.result});

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
                    backgroundColor: Colors.white.withValues(alpha: 0.6),
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

class _EmptyResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(Icons.water_drop_outlined, color: Colors.grey[500], size: 28),
          const SizedBox(height: 8),
          Text(
            'Tambahkan spesies untuk melihat indeks.',
            textAlign: TextAlign.center,
            style: context.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
