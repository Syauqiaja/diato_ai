import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';

class ExploreBottomSection extends StatefulWidget {
  const ExploreBottomSection({super.key});

  @override
  State<ExploreBottomSection> createState() => _ExploreBottomSectionState();
}

class _ExploreBottomSectionState extends State<ExploreBottomSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: AppTheme.canvasColor,
        borderRadius: BorderRadius.circular(32),
      ),
    );
  }
}
