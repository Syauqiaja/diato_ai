import 'package:diato_ai/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/assets/assets.dart';

class HomeAppBar extends StatefulWidget {
  final ScrollController _scrollController;
  const HomeAppBar({super.key, required ScrollController scrollController}) : _scrollController = scrollController;

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  double _titleOpacity = 0.0;
  double _contentOpacity = 1.0;

  final double expandedHeight = 450.0;
  final double collapsedHeight = 55.0;

  ScrollController get _scrollController => widget._scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final double scrollOffset = _scrollController.offset;

    // Calculate the range for the title to fade in
    final double fadeStart =
        (expandedHeight - collapsedHeight) * 0.5; // Start fading at 50% scroll
    final double fadeEnd =
        expandedHeight - collapsedHeight; // Fully opaque when collapsed

    double opacity = 0.0;
    if (scrollOffset >= fadeStart && scrollOffset <= fadeEnd) {
      // Calculate opacity from 0 to 1 based on scroll position
      opacity = (scrollOffset - fadeStart) / (fadeEnd - fadeStart);
    } else if (scrollOffset > fadeEnd) {
      opacity = 1.0;
    }

    setState(() {
      _titleOpacity = opacity.clamp(0.0, 1.0);
      _contentOpacity = (1 - opacity).clamp(0.0, 1.0);
    });
  }
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
            pinned: true,
            expandedHeight: 520.0,
            collapsedHeight: collapsedHeight,
            leadingWidth: 0,
            elevation: 0,
            shadowColor: Colors.transparent,
            title: Opacity(
              opacity: _titleOpacity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Diato AI"),
                  Text(
                    "We owe so much to diatoms!",
                    style: context.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
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
              background: Column(
                children: [
                  Expanded(
                    child: Opacity(
                      opacity: _contentOpacity,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 32),
                        child: Stack(
                          children: [
                            Container(
                              height: 300,
                              padding: const EdgeInsets.all(8.0),
                              child: Opacity(
                                opacity: 0.2,
                                child: Image.asset(Assets.cellBg),
                              ),
                            ),
                            Column(
                              spacing: 16,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(height: kToolbarHeight),
                                _buildTitle(context),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 16),
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.white10,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Image.asset(
                                        Assets.diatomi,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      ),
                                      Text(
                                        "Diatom",
                                        style: context.textTheme.displayMedium
                                            ?.copyWith(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: Text(
                                    "They help us make toothpaste, wall paint, and water filters - and they're responsible for some of the air you're breathing right now!",
                                    style: context.textTheme.bodyMedium
                                        ?.copyWith(
                                          height: 1.1,
                                          color: Colors.white,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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