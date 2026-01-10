import 'package:diato_ai/core/theme/theme.dart';
import 'package:diato_ai/features/explore/presentation/widgets/explore_bottom_section.dart';
import 'package:diato_ai/features/explore/presentation/widgets/explore_detail_section.dart';
import 'package:diato_ai/features/shared/widgets/spacings.dart';
import 'package:flutter/material.dart';

class ExploreScreen extends StatefulWidget {
  static const String routeName = 'explore';
  static const String routePath = '/explore';
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.secondaryCanvasColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 12,
            children: [
              Expanded(
                child:ExploreDetailSection(),
              ),
              ExploreBottomSection(),
              vSpace(kBotbarHeight)
            ],
          ),
        ),
      ),
    );
  }
}
