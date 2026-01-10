import 'package:diato_ai/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../shared/widgets/custom_bottom_app_bar.dart';

class ScannerBottomAppBar extends StatefulWidget {
  const ScannerBottomAppBar({super.key});

  @override
  State<ScannerBottomAppBar> createState() => _ScannerBottomAppBarState();
}

class _ScannerBottomAppBarState extends State<ScannerBottomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 8,
      child: Container(
        height: 64,
        padding: EdgeInsets.only(top: 12),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            shape: const CircleBorder(),
            backgroundColor: context.colorScheme.tertiary,
            foregroundColor: context.colorScheme.primary,
            elevation: 4,
            child: const FaIcon(FontAwesomeIcons.camera, size: 28),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(32)),
            clipBehavior: Clip.hardEdge,
            margin: const EdgeInsets.only(left: 8, right: 8),
            child: CustomBottomAppBar(
              shape: const CircularNotchedRectangle(),
              notchMargin: 8,
              positionInHorizontal: -8,
              color: context.colorScheme.primary,
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _NavBarItem(
                      icon: FontAwesomeIcons.images,
                      label: 'Gallery',
                      onTap: _onTapGallery,
                    ),
                    _NavBarItem(
                      icon: FontAwesomeIcons.boltLightning,
                      label: 'Flash',
                      onTap: _onTapFlash,
                    ),
                    const SizedBox(width: 64),
                    _NavBarItem(
                      icon: FontAwesomeIcons.cameraRotate,
                      label: 'Rotate Camera',
                      onTap: _onTapRotateCamera,
                    ),
                    _NavBarItem(
                      icon: FontAwesomeIcons.circleInfo,
                      label: 'Info',
                      onTap: _onTapInfo,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapGallery() {}

  void _onTapFlash() {}

  void _onTapRotateCamera() {}

  void _onTapInfo() {}
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: 48,
      child: Material(
        clipBehavior: Clip.hardEdge,
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [FaIcon(icon, size: 24, color: Colors.white)],
          ),
        ),
      ),
    );
  }
}
