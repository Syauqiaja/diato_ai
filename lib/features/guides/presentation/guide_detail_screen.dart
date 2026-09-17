import 'package:diato_ai/core/assets/assets.dart';
import 'package:diato_ai/core/theme/theme.dart';
import 'package:diato_ai/features/guides/presentation/cubit/guide_detail_cubit.dart';
import 'package:diato_ai/features/guides/presentation/cubit/guide_list_cubit.dart';
import 'package:diato_ai/features/shared/widgets/linear_line.dart';
import 'package:diato_ai/features/shared/widgets/rich_html_content.dart';
import 'package:diato_ai/features/shared/widgets/spacings.dart';
import 'package:diato_ai/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// One guide, laid out like a course, with buttons to step through the list.
class GuideDetailScreen extends StatefulWidget {
  static const String routeName = 'guide-detail';
  static const String routePath = '/guide-detail/:guideId';
  final int guideId;

  static void push(BuildContext context, int guideId) {
    context.pushNamed(
      routeName,
      pathParameters: {'guideId': guideId.toString()},
    );
  }

  const GuideDetailScreen({super.key, required this.guideId});

  @override
  State<GuideDetailScreen> createState() => _GuideDetailScreenState();
}

class _GuideDetailScreenState extends State<GuideDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GuideDetailCubit>().fetchGuideDetail(widget.guideId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final textColor = context.colorScheme.primary;

    return Scaffold(
      backgroundColor: AppTheme.canvasColor,
      body: SafeArea(
        child: BlocBuilder<GuideDetailCubit, GuideDetailState>(
          builder: (context, state) {
            if (state is GuideDetailLoading || state is GuideDetailInitial) {
              return Center(child: CircularProgressIndicator(color: textColor));
            }

            final detail = state is GuideDetailData ? state.guideDetail : null;
            final errorMessage = state is GuideDetailError ? state.message : null;

            // Guide ids come from the console, so the list position is what
            // gets numbered and stepped through.
            final listState = context.watch<GuideListCubit>().state;
            final guideIds = listState is GuideListData
                ? listState.guides.map((g) => g.id).toList()
                : <int>[];
            final currentIndex = detail != null ? guideIds.indexOf(detail.id) : -1;
            final hasPrevious = currentIndex > 0;
            final hasNext = currentIndex >= 0 && currentIndex < guideIds.length - 1;

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: textColor),
                          onPressed: () => context.pop(),
                        ),
                        Expanded(
                          child: Text(
                            'Panduan',
                            style: context.textTheme.headlineMedium?.copyWith(
                              color: textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                detail?.title ?? 'Panduan',
                                style: context.textTheme.displayLarge?.copyWith(
                                  color: textColor,
                                  height: 0.9,
                                ),
                              ),
                            ),
                            if (currentIndex >= 0)
                              Container(
                                height: 56,
                                width: 56,
                                decoration: BoxDecoration(
                                  color: textColor,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  (currentIndex + 1).toString(),
                                  style: context.textTheme.headlineLarge?.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        vSpace(16),
                        const LinearLine(),
                        vSpace(24),
                        if (errorMessage != null)
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.red.shade100,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              errorMessage,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                          )
                        else if (detail?.cover != null) ...[
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: Image.network(
                              detail!.cover!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  Assets.diatomi,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                );
                              },
                            ),
                          ),
                          vSpace(24),
                        ],
                        if (detail != null) RichHtmlContent(detail.content),
                        vSpace(48),
                        Row(
                          children: [
                            Expanded(
                              child: _StepButton(
                                label: 'Previous',
                                icon: Icons.arrow_back,
                                onPressed: hasPrevious
                                    ? () => context
                                        .read<GuideDetailCubit>()
                                        .fetchGuideDetail(guideIds[currentIndex - 1])
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _StepButton(
                                label: 'Next',
                                icon: Icons.arrow_forward,
                                iconAtEnd: true,
                                onPressed: hasNext
                                    ? () => context
                                        .read<GuideDetailCubit>()
                                        .fetchGuideDetail(guideIds[currentIndex + 1])
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        vSpace(kBotbarHeight + 24),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool iconAtEnd;
  final VoidCallback? onPressed;

  const _StepButton({
    required this.label,
    required this.icon,
    this.iconAtEnd = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme.primary;

    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      iconAlignment: iconAtEnd ? IconAlignment.end : IconAlignment.start,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        disabledBackgroundColor: color.withValues(alpha: 0.3),
        disabledForegroundColor: Colors.white.withValues(alpha: 0.5),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
