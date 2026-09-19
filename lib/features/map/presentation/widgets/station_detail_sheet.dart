import 'package:diato_ai/core/assets/assets.dart';
import 'package:diato_ai/core/theme/theme.dart';
import 'package:diato_ai/features/map/presentation/cubit/station_detail_cubit.dart';
import 'package:diato_ai/features/map/presentation/widgets/year_filter_chips.dart';
import 'package:diato_ai/features/shared/models/station_detail.dart';
import 'package:diato_ai/features/shared/widgets/image_viewer.dart';
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

/// Stacks another sheet over the station detail, sized like it.
Future<void> _showListSheet(BuildContext context, {required Widget Function(ScrollController scrollController) builder}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _SheetFrame(builder: builder),
  );
}

class StationDetailSheet extends StatelessWidget {
  const StationDetailSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return _SheetFrame(
      builder: (scrollController) => BlocBuilder<StationDetailCubit, StationDetailState>(
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
            return _StationDetailContent(station: state.station, scrollController: scrollController);
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
  }
}

class _StationDetailContent extends StatelessWidget {
  final StationDetail station;
  final ScrollController scrollController;

  const _StationDetailContent({required this.station, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final imageUrl = station.imageUrl;
    final species = station.speciesFor(null);

    return _SheetShell(
      scrollController: scrollController,
      children: [
        if (imageUrl != null) ...[
          GestureDetector(
            onTap: () => showImageViewer(
              context,
              imageUrl: imageUrl,
              heroTag: 'station-image-${station.id}',
              fallback: Image.asset(Assets.diatomi, fit: BoxFit.contain),
            ),
            child: Hero(
              tag: 'station-image-${station.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(Assets.diatomi, height: 180, width: double.infinity, fit: BoxFit.cover);
                  },
                ),
              ),
            ),
          ),
          vSpace(16),
        ],
        Text(station.title, style: context.textTheme.displaySmall?.copyWith(color: AppTheme.primaryTextColor)),
        vSpace(4),
        Row(
          children: [
            const Icon(Icons.place_outlined, size: 16, color: AppTheme.primaryTextColor),
            const SizedBox(width: 4),
            Expanded(
              child: Text('${station.latitude.toStringAsFixed(5)}, ${station.longitude.toStringAsFixed(5)}', style: context.textTheme.bodySmall?.copyWith(color: AppTheme.primaryTextColor)),
            ),
          ],
        ),
        vSpace(12),
        Row(
          children: [
            _StatChip(
              icon: Icons.biotech_outlined,
              label: '${species.length} spesies',
              onTap: () => _showListSheet(
                context,
                builder: (scrollController) => _SpeciesListContent(station: station, scrollController: scrollController),
              ),
            ),
            const SizedBox(width: 8),
            _StatChip(
              onTap: () => _showListSheet(
                context,
                builder: (scrollController) => _PhysicochemistryListContent(station: station, scrollController: scrollController),
              ),
              icon: Icons.science_outlined,
              label: '${station.physicochemistry.length} parameter fisikokimia',
            ),
          ],
        ),
        vSpace(16),
        if (station.description.isNotEmpty) HtmlWidget(station.description, enableCaching: false, renderMode: RenderMode.column),
        vSpace(24),
      ],
    );
  }
}

/// The station's species, filterable by sampling year.
class _SpeciesListContent extends StatefulWidget {
  final StationDetail station;
  final ScrollController scrollController;

  const _SpeciesListContent({required this.station, required this.scrollController});

  @override
  State<_SpeciesListContent> createState() => _SpeciesListContentState();
}

class _SpeciesListContentState extends State<_SpeciesListContent> {
  /// Year the list is filtered to; null shows every year.
  int? _selectedYear;

  @override
  Widget build(BuildContext context) {
    final station = widget.station;
    final species = station.speciesFor(_selectedYear);

    return _SheetShell(
      scrollController: widget.scrollController,
      children: [
        Text('Diatom', style: context.textTheme.titleLarge?.copyWith(color: AppTheme.primaryTextColor)),
        Text(station.title, style: context.textTheme.bodySmall?.copyWith(color: AppTheme.primaryTextColor)),
        if (station.years.isNotEmpty) ...[vSpace(12), YearFilterChips(years: station.years, selectedYear: _selectedYear, onSelected: (year) => setState(() => _selectedYear = year))],
        vSpace(8),
        if (species.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(_selectedYear == null ? 'Belum ada spesies tercatat' : 'Tidak ada spesies tercatat pada tahun $_selectedYear', style: context.textTheme.bodyMedium),
          ),
        ...species.map(
          (entry) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.name, style: context.textTheme.bodyMedium),
                if (_selectedYear == null && entry.years.isNotEmpty) Text(entry.years.join(' · '), style: context.textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
              ],
            ),
          ),
        ),
        vSpace(24),
      ],
    );
  }
}

/// The station's physicochemical readings, one parameter per row.
class _PhysicochemistryListContent extends StatelessWidget {
  final StationDetail station;
  final ScrollController scrollController;

  const _PhysicochemistryListContent({required this.station, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final readings = station.physicochemistry;

    return _SheetShell(
      scrollController: scrollController,
      children: [
        Text('Fisikokimia', style: context.textTheme.titleLarge?.copyWith(color: AppTheme.primaryTextColor)),
        Text(station.title, style: context.textTheme.bodySmall?.copyWith(color: AppTheme.primaryTextColor)),
        vSpace(8),
        if (readings.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text('Belum ada data fisikokimia', style: context.textTheme.bodyMedium),
          ),
        for (final (index, reading) in readings.indexed) ...[
          if (index > 0) const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Text(reading.parameter, style: context.textTheme.bodyMedium)),
                const SizedBox(width: 12),
                Text(
                  reading.value,
                  textAlign: TextAlign.end,
                  style: context.textTheme.bodyMedium?.copyWith(color: AppTheme.primaryTextColor, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
        vSpace(24),
      ],
    );
  }
}

/// Rounded, draggable sheet body shared by the station sheets.
class _SheetFrame extends StatelessWidget {
  final Widget Function(ScrollController scrollController) builder;

  const _SheetFrame({required this.builder});

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
          child: builder(scrollController),
        );
      },
    );
  }
}

/// Drag handle + scrollable padded body shared by every sheet state.
///
/// The app's floating bottom bar is drawn above the sheets, so the body keeps
/// the same clearance below its content as the map screen does.
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
          decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(2)),
        ),
        Expanded(
          child: ListView(controller: scrollController, padding: EdgeInsets.fromLTRB(16, 0, 16, 48 + kBottomNavigationBarHeight + MediaQuery.viewPaddingOf(context).bottom), children: children),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _StatChip({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(color: AppTheme.secondaryCanvasColor, borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppTheme.primaryTextColor),
            const SizedBox(width: 6),
            Text(label, style: context.textTheme.bodySmall?.copyWith(color: AppTheme.primaryTextColor)),
          ],
        ),
      ),
    );
  }
}
