import 'package:flutter/material.dart';

enum AppButtonColorType {
  white,
  primary,
  secondary,
  tertiary,
}

class AppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final AppButtonColorType? backgroundColor;
  final AppButtonColorType? foregroundColor;
  final EdgeInsetsGeometry? padding;
  final double? elevation;
  final double? borderRadius;

  const AppButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.backgroundColor = AppButtonColorType.primary,
    this.foregroundColor = AppButtonColorType.white,
    this.padding,
    this.elevation,
    this.borderRadius,
  });

  Color _getColor(BuildContext context, AppButtonColorType type) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (type) {
      case AppButtonColorType.white:
        return Colors.white;
      case AppButtonColorType.primary:
        return colorScheme.primary;
      case AppButtonColorType.secondary:
        return colorScheme.secondary;
      case AppButtonColorType.tertiary:
        return colorScheme.tertiary;
    }
  }

  Color _getDefaultForegroundColor(
      BuildContext context, AppButtonColorType? bgType) {
    if (bgType == null) {
      // Transparent background, use primary color for text
      return Theme.of(context).colorScheme.primary;
    }
    
    final colorScheme = Theme.of(context).colorScheme;
    switch (bgType) {
      case AppButtonColorType.white:
        return colorScheme.primary;
      case AppButtonColorType.primary:
        return Colors.white;
      case AppButtonColorType.secondary:
        return Colors.black;
      case AppButtonColorType.tertiary:
        return Colors.black;
    }
  }

  Color _getSplashColor(BuildContext context) {
    if (backgroundColor == null) {
      // Transparent background - use primary with low opacity
      return Theme.of(context).colorScheme.primary.withValues(alpha: 0.1);
    }
    
    // For solid backgrounds, use white or black splash based on foreground
    final fgColor = foregroundColor != null
        ? _getColor(context, foregroundColor!)
        : _getDefaultForegroundColor(context, backgroundColor);
    
    // If foreground is white/light, use white splash, otherwise use black
    return fgColor.computeLuminance() > 0.5
        ? Colors.white.withValues(alpha: 0.2)
        : Colors.black.withValues(alpha: 0.1);
  }

  Color _getHighlightColor(BuildContext context) {
    if (backgroundColor == null) {
      // Transparent background - use primary with low opacity
      return Theme.of(context).colorScheme.primary.withValues(alpha: 0.05);
    }
    
    // For solid backgrounds, use white or black highlight based on foreground
    final fgColor = foregroundColor != null
        ? _getColor(context, foregroundColor!)
        : _getDefaultForegroundColor(context, backgroundColor);
    
    return fgColor.computeLuminance() > 0.5
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.black.withValues(alpha: 0.05);
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor != null
        ? _getColor(context, backgroundColor!)
        : Colors.transparent;

    final fgColor = foregroundColor != null
        ? _getColor(context, foregroundColor!)
        : _getDefaultForegroundColor(context, backgroundColor);

    return Material(
      color: bgColor,
      elevation: elevation ?? (backgroundColor != null ? 2 : 0),
      borderRadius: BorderRadius.circular(borderRadius ?? 100),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onPressed,
        splashColor: _getSplashColor(context),
        highlightColor: _getHighlightColor(context),
        child: Container(
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: fgColor,
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
            child: IconTheme(
              data: IconThemeData(
                color: fgColor,
                size: 20,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}