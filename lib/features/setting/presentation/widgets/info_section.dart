
import 'package:diato_ai/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../shared/widgets/spacings.dart';

class InfoSection extends StatelessWidget {
  final String? label;
  final String content;

  const InfoSection({
    required this.label,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.canvasColor,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (label != null)
              Text(
                label!,
                style: context.textTheme.titleMedium?.copyWith(
                  color: context.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            vSpace(8),
            Text(
              content,
              style: context.textTheme.bodyMedium?.copyWith(
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoAccordionItem extends StatelessWidget {
  final String title;
  final String content;
  final bool initiallyExpanded;

  const InfoAccordionItem({
    required this.title,
    required this.content,
    this.initiallyExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.canvasColor,
      borderRadius: BorderRadius.circular(16),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          iconColor: context.colorScheme.primary,
          collapsedIconColor: context.colorScheme.primary,
          title: Text(
            title,
            style: context.textTheme.titleMedium?.copyWith(
              color: context.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          children: [
            Text(
              content,
              style: context.textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
