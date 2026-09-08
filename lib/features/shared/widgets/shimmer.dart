import 'package:flutter/material.dart';

/// Sweeps a highlight band across whatever it wraps, so skeleton placeholders
/// read as "loading" instead of as empty grey boxes.
class Shimmer extends StatefulWidget {
  final Widget child;
  const Shimmer({super.key, required this.child});

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  static const Color _base = Color(0xFFE4E6EB);
  static const Color _highlight = Color(0xFFF6F7F9);

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      // The child never changes, so build it once and let the shader animate.
      child: widget.child,
      builder: (context, child) {
        // Travels from fully off the left edge to fully off the right one.
        final double slide = _controller.value * 3 - 1;
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(slide - 1, 0),
              end: Alignment(slide + 1, 0),
              colors: const [_base, _highlight, _base],
              stops: const [0.0, 0.5, 1.0],
            ).createShader(bounds);
          },
          child: child,
        );
      },
    );
  }
}

/// A single grey block inside a [Shimmer]; the shader paints over its colour.
class ShimmerBox extends StatelessWidget {
  final double? width;
  final double height;
  final double radius;

  const ShimmerBox({super.key, this.width, required this.height, this.radius = 8});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFE4E6EB),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
