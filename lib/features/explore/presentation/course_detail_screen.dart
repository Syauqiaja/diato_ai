import 'package:diato_ai/core/assets/assets.dart';
import 'package:diato_ai/core/theme/theme.dart';
import 'package:diato_ai/features/explore/presentation/cubits/cubit/course_detail_cubit.dart';
import 'package:diato_ai/features/explore/presentation/cubits/explore_index/explore_index_cubit.dart';
import 'package:diato_ai/features/shared/widgets/linear_line.dart';
import 'package:diato_ai/features/shared/widgets/rich_html_content.dart';
import 'package:diato_ai/features/shared/widgets/spacings.dart';
import 'package:diato_ai/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CourseDetailScreen extends StatefulWidget {
  static const String routeName = 'course-detail';
  static const String routePath = '/course-detail/:courseId';
  final int courseId;

  static void push(BuildContext context, int courseId) {
    context.pushNamed(
      routeName,
      pathParameters: {'courseId': courseId.toString()},
    );
  }
  
  const CourseDetailScreen({super.key, required this.courseId});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CourseDetailCubit>().fetchCourseDetail(widget.courseId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final textColor = context.colorScheme.primary;

    return Scaffold(
      backgroundColor: AppTheme.canvasColor,
      body: SafeArea(
        child: BlocBuilder<CourseDetailCubit, CourseDetailState>(
          builder: (context, state) {
            String? title;
            String? imageUrl;
            String? content;
            int courseNumber = 0;
            bool isLoading = state is CourseDetailLoading;
            String? errorMessage;

            if (state is CourseDetailError) {
              errorMessage = state.message;
            }

            if (state is CourseDetailData) {
              final detail = state.courseDetail;
              title = detail.title;
              imageUrl = detail.cover;
              content = detail.content;
              courseNumber = detail.id;
            }

            if (isLoading) {
              return Center(
                child: CircularProgressIndicator(color: textColor),
              );
            }

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
                            'Course Detail',
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
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    "Tentang",
                                    style: context.textTheme.bodyLarge?.copyWith(
                                      color: textColor,
                                    ),
                                  ),
                                  Text(
                                    title ?? "No title available",
                                    style: context.textTheme.displayLarge?.copyWith(
                                      color: textColor,
                                      height: 0.9,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 56,
                              width: 56,
                              decoration: BoxDecoration(
                                color: textColor,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                courseNumber.toString(),
                                style: context.textTheme.headlineLarge?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        vSpace(16),
                        LinearLine(),
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
                              style: TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                          )
                        else if (imageUrl != null)
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: Image.network(
                              imageUrl,
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
                        if (content != null) RichHtmlContent(content),
                          vSpace(48),
                          BlocBuilder<ExploreIndexCubit, ExploreIndexState>(
                            builder: (context, indexState) {
                              List<int> courseIds = [];
                              if (indexState is ExploreIndexData) {
                                courseIds = indexState.courses.map((c) => c.id).toList();
                              }
                              
                              final currentIndex = courseIds.indexOf(courseNumber);
                              final hasPrevious = currentIndex > 0;
                              final hasNext = currentIndex >= 0 && currentIndex < courseIds.length - 1;
                              
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: hasPrevious
                                          ? () {
                                              final prevId = courseIds[currentIndex - 1];
                                              context.read<CourseDetailCubit>().fetchCourseDetail(prevId);
                                            }
                                          : null,
                                      icon: Icon(Icons.arrow_back),
                                      label: Text('Previous'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: textColor,
                                        foregroundColor: Colors.white,
                                        disabledBackgroundColor: textColor.withValues(alpha: 0.3),
                                        disabledForegroundColor: Colors.white.withValues(alpha: 0.5),
                                        padding: EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: hasNext
                                          ? () {
                                              final nextId = courseIds[currentIndex + 1];
                                              context.read<CourseDetailCubit>().fetchCourseDetail(nextId);
                                            }
                                          : null,
                                      icon: Icon(Icons.arrow_forward),
                                      label: Text('Next'),
                                      iconAlignment: IconAlignment.end,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: textColor,
                                        foregroundColor: Colors.white,
                                        disabledBackgroundColor: textColor.withValues(alpha: 0.3),
                                        disabledForegroundColor: Colors.white.withValues(alpha: 0.5),
                                        padding: EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
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
