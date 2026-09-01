import 'dart:ui';

import 'package:diato_ai/core/assets/assets.dart';
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.hardEdge,
        color: Colors.transparent,
        elevation: 0,
        child: Ink(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
              // The api can return an empty cover; NetworkImage would then
              // throw on an unparseable url instead of just failing to load.
              image: cover.isEmpty ? const AssetImage(Assets.diatomi) as ImageProvider : NetworkImage(cover),
              fit: BoxFit.cover,
              onError: (_, __) {},
            ),
          ),
          child: InkWell(
            splashColor: context.colorScheme.primary.withValues(alpha: 0.2),
            onTap: () => onTap(),
            child: Stack(
              children: [
                // Gradient overlay for better text readability
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                        stops: [0.5, 1.0],
                      ),
                    ),
                  ),
                ),
                // Content
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 12,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: context.textTheme.titleMedium?.copyWith(
                                  color: context.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: context.colorScheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: FaIcon(
                                FontAwesomeIcons.chevronRight,
                                size: 16,
                                color: context.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
