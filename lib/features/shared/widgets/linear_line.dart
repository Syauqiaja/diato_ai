import 'package:diato_ai/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class LinearLine extends StatelessWidget {
  final double width;
  const LinearLine({super.key, this.width = 200});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
              width: width,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 4,
                      color: context.colorScheme.secondary,
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 4,
                    color: context.colorScheme.tertiary,
                  ),
                ],
              ),
            ),
    );
  }
}