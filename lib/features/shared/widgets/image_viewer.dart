import 'package:flutter/material.dart';

/// Opens a full screen, zoomable viewer for [imageUrl].
///
/// [heroTag] should match the tag of the thumbnail that was tapped so the image
/// animates into place; pass null to skip the transition.
Future<void> showImageViewer(
  BuildContext context, {
  required String imageUrl,
  Object? heroTag,
  Widget? fallback,
}) {
  return Navigator.of(context, rootNavigator: true).push(
    PageRouteBuilder(
      opaque: false,
      barrierColor: Colors.black87,
      pageBuilder: (_, _, _) =>
          ImageViewerScreen(imageUrl: imageUrl, heroTag: heroTag, fallback: fallback),
      transitionsBuilder: (_, animation, _, child) =>
          FadeTransition(opacity: animation, child: child),
    ),
  );
}

class ImageViewerScreen extends StatefulWidget {
  final String imageUrl;
  final Object? heroTag;

  /// Shown when the network image fails to load.
  final Widget? fallback;

  const ImageViewerScreen({super.key, required this.imageUrl, this.heroTag, this.fallback});

  @override
  State<ImageViewerScreen> createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<ImageViewerScreen> with SingleTickerProviderStateMixin {
  static const double _minScale = 1;
  static const double _maxScale = 5;
  static const double _doubleTapScale = 2.5;

  final TransformationController _controller = TransformationController();
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );
  Animation<Matrix4>? _animation;
  TapDownDetails? _doubleTapDetails;

  @override
  void initState() {
    super.initState();
    _animationController.addListener(() {
      final animation = _animation;
      if (animation != null) _controller.value = animation.value;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _animateTo(Matrix4 target) {
    _animation = Matrix4Tween(begin: _controller.value, end: target).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _animationController.forward(from: 0);
  }

  void _handleDoubleTap() {
    final isZoomed = _controller.value.getMaxScaleOnAxis() > 1.01;
    if (isZoomed) {
      _animateTo(Matrix4.identity());
      return;
    }

    final position = _doubleTapDetails?.localPosition;
    if (position == null) return;

    // Zoom in around the tapped point.
    final offset = -position * (_doubleTapScale - 1);
    _animateTo(
      Matrix4.identity()
        ..translateByDouble(offset.dx, offset.dy, 0, 1)
        ..scaleByDouble(_doubleTapScale, _doubleTapScale, _doubleTapScale, 1),
    );
  }

  void _zoomBy(double factor) {
    final current = _controller.value.getMaxScaleOnAxis();
    final target = (current * factor).clamp(_minScale, _maxScale);
    if (target == current) return;

    final size = MediaQuery.sizeOf(context);
    final center = Offset(size.width / 2, size.height / 2);
    final offset = -center * (target - 1);
    _animateTo(
      Matrix4.identity()
        ..translateByDouble(offset.dx, offset.dy, 0, 1)
        ..scaleByDouble(target, target, target, 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget image = Image.network(
      widget.imageUrl,
      fit: BoxFit.contain,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const Center(child: CircularProgressIndicator(color: Colors.white));
      },
      errorBuilder: (context, error, stackTrace) =>
          widget.fallback ??
          const Center(child: Icon(Icons.broken_image_outlined, color: Colors.white54, size: 48)),
    );

    if (widget.heroTag != null) {
      image = Hero(tag: widget.heroTag!, child: image);
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onDoubleTapDown: (details) => _doubleTapDetails = details,
              onDoubleTap: _handleDoubleTap,
              child: InteractiveViewer(
                transformationController: _controller,
                minScale: _minScale,
                maxScale: _maxScale,
                clipBehavior: Clip.none,
                child: Center(child: image),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, color: Colors.white),
                        onPressed: () => _zoomBy(1 / 1.5),
                      ),
                      IconButton(
                        icon: const Icon(Icons.fullscreen_exit, color: Colors.white),
                        onPressed: () => _animateTo(Matrix4.identity()),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, color: Colors.white),
                        onPressed: () => _zoomBy(1.5),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
