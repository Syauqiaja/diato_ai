import 'package:diato_ai/features/explore/presentation/widgets/explore_item.dart';
import 'package:diato_ai/features/shared/widgets/spacings.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';

class ExploreBottomSection extends StatefulWidget {
  const ExploreBottomSection({super.key});

  @override
  State<ExploreBottomSection> createState() => _ExploreBottomSectionState();
}

class _ExploreBottomSectionState extends State<ExploreBottomSection> {
  final ScrollController _scrollController = ScrollController();
  double _scrollIndicatorPosition = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateScrollIndicator);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateScrollIndicator);
    _scrollController.dispose();
    super.dispose();
  }

  void _updateScrollIndicator() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;
      setState(() {
        _scrollIndicatorPosition = maxScroll > 0 ? currentScroll / maxScroll : 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.canvasColor,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: [
          // Scroll Indicator
          Container(
            height: 4,
            margin: EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(2),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    AnimatedPositioned(
                      duration: Duration(milliseconds: 100),
                      left: _scrollIndicatorPosition * (constraints.maxWidth - 60),
                      child: Container(
                        width: 60,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(
            height: 130,
            child: ListView.separated(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: 8,
              separatorBuilder: (context, index) => hSpace(8),
              itemBuilder: (context, index) {
                return ExploreItem(
                  title: (index + 1).toString(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
