import 'package:diato_ai/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home';
  static const String routePath = '/';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 450.0,
            collapsedHeight: 55,
            leadingWidth: 0,
            elevation: 0,
            shadowColor: Colors.transparent,
            title: Text("Diato AI"),
            toolbarHeight: 55,
            centerTitle: false,
            actionsPadding: EdgeInsets.symmetric(horizontal: 0),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(top: 32),
              stretchModes: [
                StretchMode.blurBackground,
                StretchMode.fadeTitle,
                StretchMode.zoomBackground,
              ],
              collapseMode: CollapseMode.parallax,
              centerTitle: false,
              expandedTitleScale: 1.1,
              background: Container(
                margin: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: kToolbarHeight),
                    _buildTitle(context),
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Placeholder(),
                          Text(
                            "Diatom",
                            style: context.textTheme.displayMedium?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:8.0),
                      child: Text(
                        "They help us make toothpaste, wall paint, and water filters - and they're responsible for some of the air you're breathing right now!",
                        style: context.textTheme.bodyMedium?.copyWith(
                          height: 1.1,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverFillRemaining(child: Center()),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 0),
          Text(
            "Welcome to",
            style: context.textTheme.bodyLarge?.copyWith(color: Colors.white),
          ),
          Text(
            "Diato-AI!",
            style: context.textTheme.displayLarge?.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 200,
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

          Text(
            "We owe so much to diatoms!",
            style: context.textTheme.bodySmall?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
