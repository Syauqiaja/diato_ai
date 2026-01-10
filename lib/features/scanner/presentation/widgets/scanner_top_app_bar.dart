import 'package:diato_ai/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScannerTopAppBar extends StatefulWidget {
  const ScannerTopAppBar({super.key});

  @override
  State<ScannerTopAppBar> createState() => _ScannerTopAppBarState();
}

class _ScannerTopAppBarState extends State<ScannerTopAppBar> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 16,
      right: 16,
      top: 8,
      child: Row(
        spacing: 8,
        children: [
          IconButton(
            onPressed: () {
              context.pop();
            },
            icon: Icon(Icons.arrow_back),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              shape: CircleBorder(),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(64),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Scan",
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.primary,
                      height: 1
                    ),
                  ),
                  Text(
                    "Diatom",
                    style: context.textTheme.displaySmall?.copyWith(
                      color: context.colorScheme.primary,
                      height: 0.8,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
