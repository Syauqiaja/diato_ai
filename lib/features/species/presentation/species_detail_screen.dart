import 'package:diato_ai/core/assets/assets.dart';
import 'package:diato_ai/core/theme/theme.dart';
import 'package:diato_ai/features/shared/widgets/linear_line.dart';
import 'package:diato_ai/features/shared/widgets/spacings.dart';
import 'package:diato_ai/features/species/presentation/cubit/species_detail_cubit.dart';
import 'package:diato_ai/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// One catalogue species: its picture and the pollution tolerance scores the
/// water quality index uses.
class SpeciesDetailScreen extends StatefulWidget {
  static const String routeName = 'species-detail';
  static const String routePath = '/species/:speciesId';
  final int speciesId;

  static void push(BuildContext context, int speciesId) {
    context.pushNamed(
      routeName,
      pathParameters: {'speciesId': speciesId.toString()},
    );
  }

  const SpeciesDetailScreen({super.key, required this.speciesId});

  @override
  State<SpeciesDetailScreen> createState() => _SpeciesDetailScreenState();
}

class _SpeciesDetailScreenState extends State<SpeciesDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SpeciesDetailCubit>().fetchSpeciesDetail(widget.speciesId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final textColor = context.colorScheme.primary;

    return Scaffold(
      backgroundColor: AppTheme.canvasColor,
      body: SafeArea(
        child: BlocBuilder<SpeciesDetailCubit, SpeciesDetailState>(
          builder: (context, state) {
            if (state is SpeciesDetailLoading || state is SpeciesDetailInitial) {
              return Center(child: CircularProgressIndicator(color: textColor));
            }

            final detail = state is SpeciesDetailData ? state.speciesDetail : null;
            final errorMessage =
                state is SpeciesDetailError ? state.message : null;

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
                            'Detail Spesies',
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
                        Text(
                          'Tentang',
                          style: context.textTheme.bodyLarge?.copyWith(
                            color: textColor,
                          ),
                        ),
                        Text(
                          detail?.name ?? 'Spesies',
                          style: context.textTheme.displayLarge?.copyWith(
                            color: textColor,
                            height: 0.9,
                          ),
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
                        else if (detail?.image != null)
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: Image.network(
                              detail!.image!,
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
                        if (detail != null && detail.isScored) ...[
                          vSpace(16),
                          _ScoreRow(
                            sensitivity: detail.sensitivity!,
                            indicator: detail.indicator!,
                          ),
                        ],
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

/// The two pollution tolerance scores, shown the way the calculator labels them.
class _ScoreRow extends StatelessWidget {
  final int sensitivity;
  final int indicator;

  const _ScoreRow({required this.sensitivity, required this.indicator});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _ScoreChip(label: 'Sensitivitas', value: sensitivity)),
        const SizedBox(width: 12),
        Expanded(child: _ScoreChip(label: 'Indikator', value: indicator)),
      ],
    );
  }
}

class _ScoreChip extends StatelessWidget {
  final String label;
  final int value;

  const _ScoreChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: context.colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
          ),
          Text(
            value.toString(),
            style: context.textTheme.titleLarge?.copyWith(
              color: context.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
