import 'package:camera/camera.dart';
import 'package:diato_ai/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Camera-style control deck for the scanner.
///
/// Deliberately looks like a camera app (dark deck, round shutter) rather than
/// the app's navigation bar, so it doesn't read as a place to switch tabs.
class ScannerCameraControls extends StatelessWidget {
  final VoidCallback onCapture;
  final VoidCallback onPickFromGallery;
  final VoidCallback onToggleFlash;
  final VoidCallback onRotateCamera;
  final VoidCallback onInfo;
  final FlashMode flashMode;
  final bool isCapturing;

  const ScannerCameraControls({
    super.key,
    required this.onCapture,
    required this.onPickFromGallery,
    required this.onToggleFlash,
    required this.onRotateCamera,
    required this.onInfo,
    required this.flashMode,
    required this.isCapturing,
  });

  static const Color _deckColor = Color(0xE6141733);

  @override
  Widget build(BuildContext context) {
    final flashOn = flashMode == FlashMode.torch;

    return Positioned(
      left: 16,
      right: 16,
      bottom: 16,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        decoration: BoxDecoration(
          color: _deckColor,
          borderRadius: BorderRadius.circular(32),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 16, offset: Offset(0, 6)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _PillToggle(
                  icon: FontAwesomeIcons.boltLightning,
                  label: flashOn ? 'Flash On' : 'Flash Off',
                  active: flashOn,
                  onTap: onToggleFlash,
                ),
                _PillToggle(
                  icon: FontAwesomeIcons.circleInfo,
                  label: 'Panduan',
                  onTap: onInfo,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _RoundAction(
                  icon: FontAwesomeIcons.images,
                  label: 'Galeri',
                  onTap: isCapturing ? null : onPickFromGallery,
                ),
                _ShutterButton(
                  onTap: isCapturing ? null : onCapture,
                  busy: isCapturing,
                ),
                _RoundAction(
                  icon: FontAwesomeIcons.cameraRotate,
                  label: 'Putar',
                  onTap: isCapturing ? null : onRotateCamera,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ShutterButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool busy;

  const _ShutterButton({required this.onTap, required this.busy});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Ambil foto',
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: 84,
          height: 84,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: busy
                  ? Colors.white.withValues(alpha: 0.5)
                  : context.colorScheme.tertiary,
            ),
            alignment: Alignment.center,
            child: busy
                ? const SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.white,
                    ),
                  )
                : FaIcon(
                    FontAwesomeIcons.camera,
                    size: 26,
                    color: context.colorScheme.primary,
                  ),
          ),
        ),
      ),
    );
  }
}

class _RoundAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _RoundAction({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;

    return Semantics(
      button: true,
      label: label,
      child: Opacity(
        opacity: enabled ? 1 : 0.4,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Material(
              color: Colors.white.withValues(alpha: 0.14),
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onTap,
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: Center(
                    child: FaIcon(icon, size: 22, color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: context.textTheme.labelSmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PillToggle extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _PillToggle({
    required this.icon,
    required this.label,
    required this.onTap,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = active ? context.colorScheme.primary : Colors.white;

    return Material(
      color: active
          ? context.colorScheme.tertiary
          : Colors.white.withValues(alpha: 0.14),
      shape: const StadiumBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48, minWidth: 112),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(icon, size: 16, color: foreground),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: context.textTheme.labelLarge?.copyWith(
                    color: foreground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
