import 'dart:math' as math;

import 'package:flutter/material.dart';

/// The index drawn as a ring of five segments, one per water quality band.
///
/// The ring fills clockwise from the top as [progress] runs 0 to 1, so the
/// result arrives as movement rather than as a number that was already there.
class BrdiRingGauge extends StatelessWidget {
  /// How much of the ring is filled, 0 to 1.
  final double progress;

  /// Colour of the filled part; the track behind it stays neutral.
  final Color color;

  final double size;
  final double strokeWidth;

  /// Drawn in the middle of the ring, scaled by the caller.
  final Widget child;

  const BrdiRingGauge({
    super.key,
    required this.progress,
    required this.color,
    required this.child,
    this.size = 220,
    this.strokeWidth = 22,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingPainter(
          progress: progress.clamp(0.0, 1.0),
          color: color,
          strokeWidth: strokeWidth,
        ),
        child: Center(child: child),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  /// One segment per band, with a gap between them so the ring reads as steps
  /// on a scale instead of one continuous dial.
  static const int _segments = 5;

  /// The gap wanted between two segments, in radians of the ring.
  static const double _visualGap = 0.13;

  _RingPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );

    const start = -math.pi / 2;
    const full = 2 * math.pi;

    // A round cap runs half a stroke past each end of its arc, so a gap has to
    // pay for two caps before any of it is left to see.
    final radius = (size.shortestSide - strokeWidth) / 2;
    final gap = _visualGap + strokeWidth / radius;
    final segmentSweep = full / _segments - gap;

    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withValues(alpha: 0.18);

    final filled = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = color;

    // The sweep the fill has reached, measured across the whole ring including
    // the gaps, so a segment lights up only once the fill runs through it.
    final filledSweep = full * progress;

    for (var i = 0; i < _segments; i++) {
      final segmentStart = start + i * (full / _segments) + gap / 2;
      canvas.drawArc(rect, segmentStart, segmentSweep, false, track);

      final consumed = filledSweep - (segmentStart - start);
      if (consumed <= 0) continue;

      canvas.drawArc(
        rect,
        segmentStart,
        math.min(consumed, segmentSweep),
        false,
        filled,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.color != color ||
      oldDelegate.strokeWidth != strokeWidth;
}
