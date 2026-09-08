import 'package:diato_ai/core/assets/assets.dart';
import 'package:diato_ai/core/theme/theme.dart';
import 'package:diato_ai/features/explore/presentation/course_detail_screen.dart';
import 'package:diato_ai/features/explore/presentation/cubits/explore_index/explore_index_cubit.dart';
import 'package:diato_ai/features/shared/models/course_item.dart';
import 'package:diato_ai/features/species/data/models/species_summary.dart';
import 'package:diato_ai/features/species/presentation/cubit/species_list_cubit.dart';
import 'package:diato_ai/features/species/presentation/species_detail_screen.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExploreIndexCubit>().fetchCourses();
      context.read<SpeciesListCubit>().fetchSpecies();
    });
  }

  /// The courses, in the order the console gave them.
  Widget _coursesSection(BuildContext context) {
    return BlocBuilder<ExploreIndexCubit, ExploreIndexState>(
      builder: (context, state) {
        if (state is ExploreIndexLoading) {
          return Center(child: CircularProgressIndicator(color: context.colorScheme.primary));
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

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: courses.length,
            separatorBuilder: (context, index) => vSpace(12),
            itemBuilder: (context, index) {
              final course = courses[index];
              return _ExploreItem(course: course);
            },
          );
        }

        return SizedBox.shrink();
      },
    );
  }

  /// Only the catalogue species that carry an explanation; the rest are
  /// counting rows with nothing to read yet.
  Widget _speciesSection(BuildContext context) {
    return BlocBuilder<SpeciesListCubit, SpeciesListState>(
      builder: (context, state) {
        if (state is SpeciesListLoading) {
          return Center(child: CircularProgressIndicator(color: context.colorScheme.primary));
        }

        if (state is! SpeciesListData) {
          return SizedBox.shrink();
        }

        final species = state.explained;
        if (species.isEmpty) {
          return SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Spesies',
              style: context.textTheme.headlineMedium?.copyWith(color: context.colorScheme.primary),
            ),
            vSpace(12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: species.length,
              separatorBuilder: (context, index) => vSpace(12),
              itemBuilder: (context, index) => _SpeciesItem(species: species[index]),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.secondaryCanvasColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Explore Diatom di Sungai brantas', style: context.textTheme.displayLarge?.copyWith(color: context.colorScheme.primary)),
              vSpace(16),
              Expanded(
                child: ListView(
                  children: [
                    _coursesSection(context),
                    vSpace(32),
                    _speciesSection(context),
                    vSpace(kBotbarHeight),
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

class _ExploreItem extends StatelessWidget {
  final CourseItem course;
  const _ExploreItem({required this.course});

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
          child: Image.network(
            course.cover,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(Assets.diatomi, fit: BoxFit.cover);
            },
          ),
        ),
        title: Text(
          course.title,
          style: context.textTheme.titleMedium?.copyWith(color: context.colorScheme.primary, fontWeight: FontWeight.w600),
        ),
        subtitle: Text('Course #${course.id}', style: context.textTheme.bodySmall?.copyWith(color: context.colorScheme.primary.withOpacity(0.6))),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: context.colorScheme.primary),
        onTap: () {
          CourseDetailScreen.push(context, course.id);
        },
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
          species.name,
          style: context.textTheme.titleMedium?.copyWith(
            color: context.colorScheme.primary,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.italic,
          ),
        ),
        subtitle: Text(
          species.sensitivity != null && species.indicator != null
              ? 'Sensitivitas ${species.sensitivity} · indikator ${species.indicator}'
              : 'Spesies katalog',
          style: context.textTheme.bodySmall?.copyWith(color: context.colorScheme.primary.withOpacity(0.6)),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: context.colorScheme.primary),
        onTap: () => SpeciesDetailScreen.push(context, species.id),
      ),
    );
  }
}
