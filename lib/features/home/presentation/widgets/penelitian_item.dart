import 'package:diato_ai/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PenelitianItem extends StatelessWidget {
  final String title;
  final String cover;
  final Function onTap;
  const PenelitianItem({super.key, required this.onTap, required this.title, required this.cover});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.hardEdge,
      color: Colors.transparent,
      child: Ink(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(cover),
            fit: BoxFit.cover,
          ),
        ),
        child: InkWell(
          splashColor: context.colorScheme.primary.withValues(alpha: 0.2),
          onTap: () => onTap(),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colorScheme.primary,
                      ),
                    ),
                  ),
                  FaIcon(FontAwesomeIcons.chevronRight, size: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
