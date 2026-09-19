import 'dart:async';

import 'package:diato_ai/core/assets/assets.dart';
import 'package:diato_ai/core/theme/theme.dart';
import 'package:diato_ai/features/contents/data/models/content_item.dart';
import 'package:diato_ai/features/contents/data/models/content_search_result.dart';
import 'package:diato_ai/features/contents/data/models/content_type.dart';
import 'package:diato_ai/features/contents/presentation/content_detail_screen.dart';
import 'package:diato_ai/features/contents/presentation/cubit/content_list_cubit.dart';
import 'package:diato_ai/features/contents/presentation/cubit/content_search_cubit.dart';
import 'package:diato_ai/features/contents/presentation/widgets/highlighted_text.dart';
import 'package:diato_ai/features/shared/widgets/shimmer.dart';
import 'package:diato_ai/features/shared/widgets/spacings.dart';
import 'package:diato_ai/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExploreScreen extends StatefulWidget {
  static const String routeName = 'explore';
  static const String routePath = '/explore';
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  /// Tall enough for the cover, the title over two lines and the caption.
  static const double _courseRailHeight = 236;

  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ContentListCubit>().fetchAll();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    setState(() {});
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted) context.read<ContentSearchCubit>().search(query);
    });
  }

  void _clearSearch() {
    _debounce?.cancel();
    _searchController.clear();
    context.read<ContentSearchCubit>().clear();
    setState(() {});
  }

  Widget _searchField(BuildContext context) {
    return TextField(
      controller: _searchController,
      onChanged: _onQueryChanged,
      textInputAction: TextInputAction.search,
      onSubmitted: (query) {
        _debounce?.cancel();
        context.read<ContentSearchCubit>().search(query);
      },
      decoration: InputDecoration(
        hintText: 'Cari course, panduan, atau famili...',
        prefixIcon: const Icon(Icons.search, size: 20),
        suffixIcon: _searchController.text.isEmpty
            ? null
            : IconButton(icon: const Icon(Icons.close, size: 20), onPressed: _clearSearch),
        filled: true,
        fillColor: AppTheme.canvasColor,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  /// Matches across every list: title hits first, each with the line it
  /// matched on.
  Widget _searchResults(BuildContext context, ContentSearchState state) {
    if (state is ContentSearchLoading) {
      return _skeletonList(4);
    }

    if (state is ContentSearchError) {
      return _message(context, state.message, color: Colors.red);
    }

    if (state is ContentSearchData) {
      if (state.results.isEmpty) {
        return _message(context, 'Tidak ada hasil untuk "${state.query}"');
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${state.results.length} hasil',
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.primary.withValues(alpha: 0.6),
            ),
          ),
          vSpace(12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.results.length,
            separatorBuilder: (context, index) => vSpace(12),
            itemBuilder: (context, index) => _SearchResultItem(result: state.results[index], query: state.query),
          ),
        ],
      );
    }

    return SizedBox.shrink();
  }

  /// The courses, in the order the console gave them, as a swipeable rail.
  Widget _coursesSection(BuildContext context, ContentSection section) {
    if (section.isLoading) {
      return SizedBox(
        height: _courseRailHeight,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          separatorBuilder: (context, index) => hSpace(12),
          itemBuilder: (context, index) => const _CourseCardSkeleton(),
        ),
      );
    }

    if (section.status == ContentListStatus.error) {
      return _message(context, section.error ?? '', color: Colors.red);
    }

    final courses = section.items;
    if (courses.isEmpty) {
      return Center(
        child: Text('No courses available', style: context.textTheme.bodyLarge?.copyWith(color: context.colorScheme.primary)),
      );
    }

    return SizedBox(
      height: _courseRailHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: courses.length,
        separatorBuilder: (context, index) => hSpace(12),
        itemBuilder: (context, index) => _CourseCard(course: courses[index], number: index + 1),
      ),
    );
  }

  /// A vertical list of guides or families; nothing at all when it is empty.
  Widget _verticalSection(
    BuildContext context,
    ContentSection section, {
    required String Function(int number) subtitle,
  }) {
    if (section.isLoading) {
      return _skeletonList(2);
    }

    if (section.items.isEmpty) {
      return SizedBox.shrink();
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: section.items.length,
      separatorBuilder: (context, index) => vSpace(12),
      itemBuilder: (context, index) => _ListItem(item: section.items[index], subtitle: subtitle(index + 1)),
    );
  }

  Widget _skeletonList(int count) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: count,
      separatorBuilder: (context, index) => vSpace(12),
      itemBuilder: (context, index) => const _ListItemSkeleton(),
    );
  }

  Widget _message(BuildContext context, String message, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Text(
          message,
          style: context.textTheme.bodyMedium?.copyWith(color: color ?? context.colorScheme.primary),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: context.textTheme.displayLarge?.copyWith(color: context.colorScheme.primary),
    );
  }

  List<Widget> _lists(BuildContext context, ContentListState state) {
    final guides = state.of(ContentType.guide);
    final families = state.of(ContentType.family);

    return [
      _sectionTitle(context, 'Tentang Diatom'),
      vSpace(16),
      _coursesSection(context, state.of(ContentType.course)),
      vSpace(32),
      if (guides.isLoading || guides.items.isNotEmpty) ...[
        _sectionTitle(context, 'Panduan'),
        vSpace(16),
        _verticalSection(context, guides, subtitle: (number) => 'Panduan $number'),
        vSpace(32),
      ],
      _sectionTitle(context, 'Diatom di Sungai Brantas'),
      vSpace(16),
      _verticalSection(context, families, subtitle: (number) => 'Famili'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.secondaryCanvasColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<ContentSearchCubit, ContentSearchState>(
            builder: (context, searchState) {
              return BlocBuilder<ContentListCubit, ContentListState>(
                builder: (context, listState) {
                  return ListView(
                    children: [
                      _searchField(context),
                      vSpace(24),
                      if (searchState is ContentSearchIdle)
                        ..._lists(context, listState)
                      else
                        _searchResults(context, searchState),
                      vSpace(kBotbarHeight),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Cover picture, or the bundled one when there is none or it fails to load.
class _Cover extends StatelessWidget {
  final String? url;
  const _Cover({required this.url});

  @override
  Widget build(BuildContext context) {
    if (url == null) {
      return Image.asset(Assets.diatomi, fit: BoxFit.cover);
    }

    return Image.network(
      url!,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Image.asset(Assets.diatomi, fit: BoxFit.cover),
    );
  }
}

/// One course on the horizontal rail: cover above, title below.
class _CourseCard extends StatelessWidget {
  final ContentItem course;
  final int number;
  const _CourseCard({required this.course, required this.number});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 168,
      child: Material(
        color: AppTheme.canvasColor,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => ContentDetailScreen.push(context, course.id),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 120,
                width: double.infinity,
                child: _Cover(url: course.cover),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.titleMedium?.copyWith(
                        color: context.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    vSpace(4),
                    Text(
                      'Course #$number',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.primary.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One guide or family in a vertical list.
class _ListItem extends StatelessWidget {
  final ContentItem item;
  final String subtitle;
  const _ListItem({required this.item, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.canvasColor,
      borderRadius: BorderRadius.circular(16),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          clipBehavior: Clip.hardEdge,
          child: _Cover(url: item.cover),
        ),
        title: Text(
          item.title,
          style: context.textTheme.titleMedium?.copyWith(
            color: context.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.primary.withValues(alpha: 0.6),
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: context.colorScheme.primary),
        onTap: () => ContentDetailScreen.push(context, item.id),
      ),
    );
  }
}

/// A search hit: what kind it is, its title and the line the query is on,
/// with the query picked out in both.
class _SearchResultItem extends StatelessWidget {
  final ContentSearchResult result;
  final String query;
  const _SearchResultItem({required this.result, required this.query});

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return Material(
      color: AppTheme.canvasColor,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => ContentDetailScreen.push(context, result.id),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                clipBehavior: Clip.hardEdge,
                child: _Cover(url: result.cover),
              ),
              hSpace(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.type.label,
                      style: context.textTheme.labelSmall?.copyWith(
                        color: primary.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    vSpace(2),
                    HighlightedText(
                      result.title,
                      query: query,
                      maxLines: 2,
                      style: context.textTheme.titleMedium?.copyWith(
                        color: primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (result.snippet != null) ...[
                      vSpace(4),
                      HighlightedText(
                        result.snippet!,
                        query: query,
                        maxLines: 2,
                        style: context.textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
                      ),
                    ],
                  ],
                ),
              ),
              hSpace(8),
              Padding(
                padding: const EdgeInsets.only(top: 22),
                child: Icon(Icons.arrow_forward_ios, size: 16, color: primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Stand-in for [_CourseCard] while the rail is loading.
class _CourseCardSkeleton extends StatelessWidget {
  const _CourseCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 168,
      child: Material(
        color: AppTheme.canvasColor,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: Shimmer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ShimmerBox(width: double.infinity, height: 120, radius: 0),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ShimmerBox(width: double.infinity, height: 14),
                    vSpace(6),
                    const ShimmerBox(width: 100, height: 14),
                    vSpace(8),
                    const ShimmerBox(width: 64, height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Stand-in for [_ListItem] or [_SearchResultItem] while loading.
class _ListItemSkeleton extends StatelessWidget {
  const _ListItemSkeleton();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.canvasColor,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Shimmer(
          child: Row(
            children: [
              const ShimmerBox(width: 60, height: 60, radius: 12),
              hSpace(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ShimmerBox(width: double.infinity, height: 14),
                    vSpace(8),
                    const ShimmerBox(width: 120, height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
