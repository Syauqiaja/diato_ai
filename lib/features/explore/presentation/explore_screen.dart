import 'package:diato_ai/core/assets/assets.dart';
import 'package:diato_ai/core/theme/theme.dart';
import 'package:diato_ai/features/explore/presentation/course_detail_screen.dart';
import 'package:diato_ai/features/explore/presentation/cubits/explore_index/explore_index_cubit.dart';
import 'package:diato_ai/features/guides/presentation/cubit/guide_list_cubit.dart';
import 'package:diato_ai/features/guides/presentation/guide_detail_screen.dart';
import 'package:diato_ai/features/shared/models/course_item.dart';
import 'package:diato_ai/features/shared/models/guide_item.dart';
import 'package:diato_ai/features/species/data/models/species_summary.dart';
import 'package:diato_ai/features/species/presentation/cubit/species_list_cubit.dart';
import 'package:diato_ai/features/species/presentation/species_detail_screen.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExploreIndexCubit>().fetchCourses();
      context.read<GuideListCubit>().fetchGuides();
      context.read<SpeciesListCubit>().fetchSpecies();
    });
  }

  /// The courses, in the order the console gave them, as a swipeable rail.
  Widget _coursesSection(BuildContext context) {
    return BlocBuilder<ExploreIndexCubit, ExploreIndexState>(
      builder: (context, state) {
        if (state is ExploreIndexLoading) {
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

        if (state is ExploreIndexError) {
          return Center(
            child: Text(
              state.message,
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          );
        }

        if (state is ExploreIndexData) {
          final courses = state.courses;

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
              itemBuilder: (context, index) => _CourseCard(course: courses[index]),
            ),
          );
        }

        return SizedBox.shrink();
      },
    );
  }

  /// The procedures, listed the same way as the species below them.
  Widget _guidesSection(BuildContext context) {
    return BlocBuilder<GuideListCubit, GuideListState>(
      builder: (context, state) {
        if (state is GuideListLoading) {
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 2,
            separatorBuilder: (context, index) => vSpace(12),
            itemBuilder: (context, index) => const _SpeciesItemSkeleton(),
          );
        }

        if (state is! GuideListData || state.guides.isEmpty) {
          return SizedBox.shrink();
        }

        final guides = state.guides;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _sectionTitle(context, 'Panduan'),
            vSpace(16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: guides.length,
              separatorBuilder: (context, index) => vSpace(12),
              itemBuilder: (context, index) => _GuideItem(guide: guides[index], number: index + 1),
            ),
            vSpace(32),
          ],
        );
      },
    );
  }

  /// Only the catalogue species that carry an explanation; the rest are
  /// counting rows with nothing to read yet.
  Widget _speciesSection(BuildContext context) {
    return BlocBuilder<SpeciesListCubit, SpeciesListState>(
      builder: (context, state) {
        if (state is SpeciesListLoading) {
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            separatorBuilder: (context, index) => vSpace(12),
            itemBuilder: (context, index) => const _SpeciesItemSkeleton(),
          );
        }

        if (state is! SpeciesListData) {
          return SizedBox.shrink();
        }

        final species = state.explained;
        if (species.isEmpty) {
          return SizedBox.shrink();
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: species.length,
          separatorBuilder: (context, index) => vSpace(12),
          itemBuilder: (context, index) => _SpeciesItem(species: species[index]),
        );
      },
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: context.textTheme.displayLarge?.copyWith(color: context.colorScheme.primary),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.secondaryCanvasColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              _sectionTitle(context, 'Tentang Diatom'),
              vSpace(16),
              _coursesSection(context),
              vSpace(32),
              _guidesSection(context),
              _sectionTitle(context, 'Diatom di Sungai Brantas'),
              vSpace(16),
              _speciesSection(context),
              vSpace(kBotbarHeight),
            ],
          ),
        ),
      ),
    );
  }
}

/// One course on the horizontal rail: cover above, title below.
class _CourseCard extends StatelessWidget {
  final CourseItem course;
  const _CourseCard({required this.course});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 168,
      child: Material(
        color: AppTheme.canvasColor,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => CourseDetailScreen.push(context, course.id),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 120,
                width: double.infinity,
                child: Image.network(
                  course.cover,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(Assets.diatomi, fit: BoxFit.cover);
                  },
                ),
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
                      'Course #${course.id}',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.primary.withOpacity(0.6),
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

/// One guide in the list, styled like [_SpeciesItem].
class _GuideItem extends StatelessWidget {
  final GuideItem guide;
  final int number;
  const _GuideItem({required this.guide, required this.number});

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
          child: guide.cover != null
              ? Image.network(
                  guide.cover!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(Assets.diatomi, fit: BoxFit.cover);
                  },
                )
              : Image.asset(Assets.diatomi, fit: BoxFit.cover),
        ),
        title: Text(
          guide.title,
          style: context.textTheme.titleMedium?.copyWith(
            color: context.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          'Panduan $number',
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.primary.withValues(alpha: 0.6),
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: context.colorScheme.primary),
        onTap: () => GuideDetailScreen.push(context, guide.id),
      ),
    );
  }
}

class _SpeciesItem extends StatelessWidget {
  final SpeciesSummary species;
  const _SpeciesItem({required this.species});

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
          child: species.image != null
              ? Image.network(
                  species.image!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(Assets.diatomi, fit: BoxFit.cover);
                  },
                )
              : Image.asset(Assets.diatomi, fit: BoxFit.cover),
        ),
        title: Text(
          species.title,
          style: context.textTheme.titleMedium?.copyWith(
            color: context.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          species.name,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.primary.withOpacity(0.6),
            fontStyle: FontStyle.italic,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: context.colorScheme.primary),
        onTap: () => SpeciesDetailScreen.push(context, species.id),
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

/// Stand-in for [_SpeciesItem] while the catalogue is loading.
class _SpeciesItemSkeleton extends StatelessWidget {
  const _SpeciesItemSkeleton();

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
