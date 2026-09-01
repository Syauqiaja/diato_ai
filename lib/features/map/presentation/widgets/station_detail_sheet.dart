import 'package:diato_ai/core/assets/assets.dart';
import 'package:diato_ai/core/theme/theme.dart';
import 'package:diato_ai/features/map/presentation/cubit/station_detail_cubit.dart';
import 'package:diato_ai/features/shared/models/station_detail.dart';
import 'package:diato_ai/features/shared/widgets/spacings.dart';
import 'package:diato_ai/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

/// Opens the station detail bottom sheet and kicks off the detail request.
///
/// [context] must be a context below the [StationDetailCubit] provider; the
/// cubit is handed to the modal route explicitly because modal routes are
/// built from the navigator's context, not this one.
Future<void> showStationDetailSheet(BuildContext context, int stationId) {
  final cubit = context.read<StationDetailCubit>();
  cubit.getStationDetail(stationId);

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider.value(value: cubit, child: const StationDetailSheet()),
  );
}

class StationDetailSheet extends StatelessWidget {
  const StationDetailSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppTheme.canvasColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          clipBehavior: Clip.hardEdge,
          child: BlocBuilder<StationDetailCubit, StationDetailState>(
            builder: (context, state) {
              if (state is StationDetailError) {
                return _SheetShell(
                  scrollController: scrollController,
                  children: [
                    vSpace(32),
                    Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              }

              if (state is StationDetailLoaded) {
                return _StationDetailContent(
                  station: state.station,
                  scrollController: scrollController,
                );
              }

              return _SheetShell(
                scrollController: scrollController,
                children: [
                  vSpace(32),
                  Center(child: CircularProgressIndicator(color: context.colorScheme.primary)),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _StationDetailContent extends StatelessWidget {
  final StationDetail station;
  final ScrollController scrollController;

  const _StationDetailContent({required this.station, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final imageUrl = station.imageUrl;

    return _SheetShell(
      scrollController: scrollController,
      children: [
        if (imageUrl != null) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  Assets.diatomi,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          vSpace(16),
        ],
        Text(
          station.title,
          style: context.textTheme.displaySmall?.copyWith(color: AppTheme.primaryTextColor),
        ),
        vSpace(4),
        Row(
          children: [
            const Icon(Icons.place_outlined, size: 16, color: AppTheme.primaryTextColor),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                '${station.latitude.toStringAsFixed(5)}, ${station.longitude.toStringAsFixed(5)}',
                style: context.textTheme.bodySmall?.copyWith(color: AppTheme.primaryTextColor),
              ),
            ),
          ],
        ),
        vSpace(12),
        Row(
          children: [
            _StatChip(
              icon: Icons.biotech_outlined,
              label: '${station.totalSpeciesCount} spesies',
            ),
            const SizedBox(width: 8),
            _StatChip(
              icon: Icons.grain,
              label: '${station.totalIndividualsCount} individu',
            ),
          ],
        ),
        vSpace(16),
        if (station.description.isNotEmpty)
          HtmlWidget(
            station.description,
            enableCaching: false,
            renderMode: RenderMode.column,
          ),
        if (station.foundSpecies.isNotEmpty) ...[
          vSpace(24),
          Text(
            'Spesies Ditemukan',
            style: context.textTheme.titleMedium?.copyWith(color: AppTheme.primaryTextColor),
          ),
          vSpace(8),
          ...station.foundSpecies.map(
            (species) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Expanded(child: Text(species.name, style: context.textTheme.bodyMedium)),
                  Text(
                    '${species.count}',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.primaryTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        vSpace(24),
      ],
    );
  }
}

/// Drag handle + scrollable padded body shared by every sheet state.
class _SheetShell extends StatelessWidget {
  final ScrollController scrollController;
  final List<Widget> children;

  const _SheetShell({required this.scrollController, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 12, bottom: 8),
          height: 4,
          width: 44,
          decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Expanded(
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            children: children,
          ),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.secondaryCanvasColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppTheme.primaryTextColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: context.textTheme.bodySmall?.copyWith(color: AppTheme.primaryTextColor),
          ),
        ],
      ),
    );
  }
}
