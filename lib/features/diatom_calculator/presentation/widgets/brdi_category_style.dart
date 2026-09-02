import 'package:flutter/material.dart';

import '../../domain/brdi_calculator.dart';

/// How each water quality band is coloured.
///
/// Red through green reads as "bad through good" at a glance, which the app's
/// blue palette cannot express, so these bands carry their own colours. They
/// run in one order everywhere: the badge, the gauge and the saved list.
extension BrdiCategoryStyle on BrdiCategory {
  Color get color => switch (this) {
        BrdiCategory.sangatBuruk => const Color(0xFFA83A2C),
        BrdiCategory.buruk => const Color(0xFFC97B3D),
        BrdiCategory.sedang => const Color(0xFFB8A23C),
        BrdiCategory.baik => const Color(0xFF4F8F6B),
        BrdiCategory.sangatBaik => const Color(0xFF1F6E5C),
      };

  Color get background => switch (this) {
        BrdiCategory.sangatBuruk => const Color(0xFFFBEAE7),
        BrdiCategory.buruk => const Color(0xFFFBF0E4),
        BrdiCategory.sedang => const Color(0xFFFAF6E2),
        BrdiCategory.baik => const Color(0xFFE9F3ED),
        BrdiCategory.sangatBaik => const Color(0xFFE2F1EC),
      };

  Color get foreground => switch (this) {
        BrdiCategory.sangatBuruk => const Color(0xFF8C2E22),
        BrdiCategory.buruk => const Color(0xFF95591E),
        BrdiCategory.sedang => const Color(0xFF8A781F),
        BrdiCategory.baik => const Color(0xFF357152),
        BrdiCategory.sangatBaik => const Color(0xFF175A4A),
      };
}

/// The index formatted the way it is read locally: two decimals, comma.
String formatIndex(double di) => di.toStringAsFixed(2).replaceAll('.', ',');
