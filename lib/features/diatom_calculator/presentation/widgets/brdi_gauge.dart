import 'package:flutter/material.dart';

import '../../domain/brdi_calculator.dart';
import 'brdi_category_style.dart';

/// The 1–5 scale with a marker at the current index, so a bare number reads as
/// a position between "sangat buruk" and "sangat baik".
class BrdiGauge extends StatelessWidget {
  final double di;

  const BrdiGauge({super.key, required this.di});

  @override
  Widget build(BuildContext context) {
    // The scale runs 1 to 5; anything outside that pins to an end rather than
    // sliding the marker off the bar.
    final position = ((di - 1) / 4).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            const markerWidth = 3.0;
            return SizedBox(
              height: 16,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: Row(
                        children: [
                          for (final category in BrdiCategory.values)
                            Expanded(
                              child: Container(
                                height: 8,
                                color: category.color,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: (constraints.maxWidth - markerWidth) * position,
                    child: Container(
                      width: markerWidth,
                      height: 16,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1B2A28),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('1 · sangat buruk', style: _scaleLabel),
            Text('5 · sangat baik', style: _scaleLabel),
          ],
        ),
      ],
    );
  }

  static const TextStyle _scaleLabel = TextStyle(
    fontSize: 11,
    color: Color(0xFF93A19D),
  );
}
