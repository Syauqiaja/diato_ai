import 'package:diato_ai/core/assets/assets.dart';
import 'package:diato_ai/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class ExploreItem extends StatelessWidget {
  final String title;
  const ExploreItem({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      width: 100,
      decoration: BoxDecoration(
        color: context.colorScheme.secondary,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Image.asset(
            Assets.diatomi,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: context.theme.canvasColor,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                title,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
