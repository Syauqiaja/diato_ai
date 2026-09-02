import 'package:flutter/material.dart';

import '../../domain/brdi_calculator.dart';
import 'brdi_category_style.dart';

class BrdiCategoryBadge extends StatelessWidget {
  final BrdiCategory category;
  final bool dense;

  const BrdiCategoryBadge({
    super.key,
    required this.category,
    this.dense = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 8 : 12,
        vertical: dense ? 2 : 5,
      ),
      decoration: BoxDecoration(
        color: category.background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        category.label,
        style: TextStyle(
          fontSize: dense ? 11 : 12,
          fontWeight: FontWeight.w600,
          color: category.foreground,
        ),
      ),
    );
  }
}
