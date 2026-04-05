import 'package:diato_ai/core/assets/assets.dart';
import 'package:diato_ai/features/explore/presentation/cubits/cubit/course_detail_cubit.dart';
import 'package:diato_ai/features/shared/widgets/linear_line.dart';
import 'package:diato_ai/features/shared/widgets/spacings.dart';
import 'package:diato_ai/utils/extensions/context_extensions.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../../../core/theme/theme.dart';

class ExploreDetailSection extends StatefulWidget {
  const ExploreDetailSection({super.key});

  @override
  State<ExploreDetailSection> createState() => _ExploreDetailSectionState();
}

class _ExploreDetailSectionState extends State<ExploreDetailSection> {
  @override
  Widget build(BuildContext context) {
    final textColor = context.colorScheme.primary;

    return BlocBuilder<CourseDetailCubit, CourseDetailState>(
      builder: (context, state) {
        // Default values
        String? title;
        String? imageUrl;
        String? content;
        int courseNumber = 0;
        bool isLoading = state is CourseDetailLoading;
        String? errorMessage;

        if (isLoading) {
          return Container(
            decoration: BoxDecoration(color: AppTheme.canvasColor, borderRadius: BorderRadius.circular(32)),
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator(color: textColor)),
          );
        }

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

        return Container(
          decoration: BoxDecoration(color: AppTheme.canvasColor, borderRadius: BorderRadius.circular(32)),
          padding: EdgeInsets.all(24),
          child: SingleChildScrollView(
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
                          Text("Tentang", style: context.textTheme.bodyLarge?.copyWith(color: textColor)),
                          Text(title ?? "No title available", style: context.textTheme.displayLarge?.copyWith(color: textColor, height: 0.9)),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 56,
                        width: 56,
                        decoration: BoxDecoration(color: textColor, shape: BoxShape.circle),
                        alignment: Alignment.center,
                        child: isLoading ? SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Text(courseNumber.toString(), style: context.textTheme.headlineLarge?.copyWith(color: Colors.white)),
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
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.red.shade100),
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
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
                    clipBehavior: Clip.hardEdge,
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(Assets.diatomi, fit: BoxFit.cover, width: double.infinity);
                      },
                    ),
                  ),
                vSpace(24),
                if (content != null)
                  HtmlWidget(
                    content,
                    enableCaching: false,
                    renderMode: RenderMode.column,
                    buildAsync: true,
                    customWidgetBuilder: (element) {
                      switch (element.localName) {
                        case "h1":
                          return Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 4, left: 8),
                            child: Text(
                              element.text,
                              style: TextStyle(fontSize: 22, height: 1, fontFamily: "AndersonGrotesk", fontWeight: FontWeight.w400),
                            ),
                          );
                        case "h2":
                          return Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 4, left: 8),
                            child: Text(
                              element.text,
                              style: TextStyle(fontSize: 18, height: 1, fontFamily: "AndersonGrotesk", fontWeight: FontWeight.w600),
                            ),
                          );
                        case "h3":
                          return Padding(
                            padding: const EdgeInsets.only(top: 8, left: 8),
                            child: Text(
                              element.text,
                              style: TextStyle(fontSize: 16, height: 1, fontFamily: "AndersonGrotesk", fontWeight: FontWeight.w600),
                            ),
                          );
                        case "h4":
                          return Padding(
                            padding: const EdgeInsets.only(top: 8, left: 8),
                            child: Text(
                              element.text,
                              style: TextStyle(fontSize: 14, height: 1, fontFamily: "AndersonGrotesk", fontWeight: FontWeight.w600),
                            ),
                          );
                        case "h5":
                          return Padding(
                            padding: const EdgeInsets.only(top: 8, left: 8),
                            child: Text(
                              element.text,
                              style: TextStyle(fontSize: 12, height: 1, fontFamily: "AndersonGrotesk", fontWeight: FontWeight.w600),
                            ),
                          );
                        case "img":
                          final url = element.attributes['src'] ?? "";
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: GestureDetector(
                              onTap: () {
                                showImageViewerPager(context, SingleImageProvider(NetworkImage(url)), immersive: false, useSafeArea: true, infinitelyScrollable: false, backgroundColor: Colors.black54);
                              },
                              child: Image.network(url, fit: BoxFit.contain),
                            ),
                          );
                        default:
                          return null;
                      }
                    },
                    textStyle: TextStyle(fontFamily: "georgia", height: 1.4, color: Theme.of(context).textTheme.bodyLarge?.color, fontWeight: FontWeight.w500),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
