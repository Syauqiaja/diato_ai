import 'package:diato_ai/features/shared/widgets/custom_bottom_app_bar.dart';
import 'package:diato_ai/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class AppLayout extends StatefulWidget {
  final StatefulNavigationShell child;
  const AppLayout({super.key, required this.child});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Stack(
        children: [
          Positioned.fill(child: widget.child),
          Positioned(
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
                  child: const FaIcon(FontAwesomeIcons.qrcode, size: 28),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                bottomNavigationBar: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  clipBehavior: Clip.hardEdge,
                  margin: const EdgeInsets.only(
                    left: 8,
                    right: 8,
                  ),
                  child: CustomBottomAppBar(
                    shape: const CircularNotchedRectangle(),
                    notchMargin: 8,
                    positionInHorizontal: -8,
                    color: context.colorScheme.primary,
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _NavBarItem(
                            icon: FontAwesomeIcons.house,
                            label: 'Home',
                            isSelected: widget.child.currentIndex == 0,
                            onTap: () => _onItemTapped(0),
                          ),
                          _NavBarItem(
                            icon: FontAwesomeIcons.compass,
                            label: 'Explore',
                            isSelected: widget.child.currentIndex == 1,
                            onTap: () => _onItemTapped(1),
                          ),
                          const SizedBox(width: 64), // Space for FAB
                          _NavBarItem(
                            icon: FontAwesomeIcons.map,
                            label: 'Map',
                            isSelected: widget.child.currentIndex == 2,
                            onTap: () => _onItemTapped(2),
                          ),
                          _NavBarItem(
                            icon: FontAwesomeIcons.clockRotateLeft,
                            label: 'History',
                            isSelected: widget.child.currentIndex == 3,
                            onTap: () => _onItemTapped(3),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    widget.child.goBranch(
      index,
      initialLocation: index == widget.child.currentIndex,
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      width: 38,
      child: Material(
        clipBehavior: Clip.hardEdge,
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                icon,
                size: 24,
                color: isSelected
                    ? context.colorScheme.tertiary
                    : Colors.white.withValues(alpha: 0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
