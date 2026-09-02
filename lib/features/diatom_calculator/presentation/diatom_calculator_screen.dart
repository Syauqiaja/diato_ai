import 'package:diato_ai/features/shared/widgets/linear_line.dart';
import 'package:diato_ai/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';

class AnaylitcsScreen extends StatefulWidget {
  static const String routeName = 'analytics';
  static const String routePath = '/analytics';
  const AnaylitcsScreen({super.key});

  @override
  State<AnaylitcsScreen> createState() => _AnaylitcsScreenState();
}

class _AnaylitcsScreenState extends State<AnaylitcsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'BRDI',
                          style: context.textTheme.displayMedium?.copyWith(
                            color: AppTheme.primaryTextColor,
                          ),
                        ),
                        Text(
                          'Brantas River Diatom Indeks',
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.primaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: context.colorScheme.secondary.withValues(
                        alpha: 0.15,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.info,
                      color: context.colorScheme.primary,
                      size: 32,
                    ),
                  ),
                ],
              ),
              LinearLine(),
              const SizedBox(height: 16,),
              ListView.builder(
                itemCount: 5,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ListTile(
                    contentPadding: EdgeInsets.all(0),
                    leading: Container(
                      height: 64,
                      width: 64,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Image(
                        image: AssetImage('assets/diatomi.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    titleAlignment: ListTileTitleAlignment.top,
                    title: Text(
                      'Diatom Sample 1',
                      style: context.textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      'Lokasi: Sungai Brantas, Malang',
                      style: context.textTheme.bodySmall,
                    ),
                    trailing: SizedBox(width: 64, child: TextField()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
