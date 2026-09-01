import 'package:diato_ai/core/theme/theme.dart';
import 'package:diato_ai/features/map/presentation/cubit/station_list_cubit.dart';
import 'package:diato_ai/features/map/presentation/widgets/station_detail_sheet.dart';
import 'package:diato_ai/features/shared/models/station.dart';
import 'package:diato_ai/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../shared/widgets/linear_line.dart';

class MapScreen extends StatefulWidget {
  static const String routeName = 'map';
  static const String routePath = '/map';
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  /// Rough center of Indonesia, used when there is nothing to fit to.
  static const LatLng _fallbackCenter = LatLng(-2.5, 118.0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StationListCubit>().getStations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16, 
          bottom: 48 + kBottomNavigationBarHeight
        ),
        child: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'PETA',
                          style: context.textTheme.displayMedium?.copyWith(
                            color: AppTheme.primaryTextColor,
                          ),
                        ),
                        Text(
                          'Peta Sebaran Lokasi Diatom',
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.primaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          
              LinearLine(),
          
              SizedBox(height: 16),
          
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BlocBuilder<StationListCubit, StationListState>(
                    builder: (context, state) {
                      if (state is StationListError) {
                        return _MapPlaceholder(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                state.message,
                                style: const TextStyle(color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                              TextButton(
                                onPressed: () => context.read<StationListCubit>().getStations(),
                                child: const Text('Coba Lagi'),
                              ),
                            ],
                          ),
                        );
                      }

                      if (state is StationListLoaded) {
                        return _StationMap(stations: state.stations);
                      }

                      return _MapPlaceholder(
                        child: CircularProgressIndicator(color: context.colorScheme.primary),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StationMap extends StatelessWidget {
  final List<Station> stations;

  const _StationMap({required this.stations});

  @override
  Widget build(BuildContext context) {
    final points = stations.map((station) => LatLng(station.latitude, station.longitude)).toList();

    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            initialCenter: _MapScreenState._fallbackCenter,
            initialZoom: 4.5,
            initialCameraFit: points.isEmpty
                ? null
                : CameraFit.bounds(
                    bounds: LatLngBounds.fromPoints(points),
                    padding: const EdgeInsets.all(48),
                    maxZoom: 13,
                  ),
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.diato_ai',
            ),
            MarkerLayer(
              markers: [
                for (final station in stations)
                  Marker(
                    point: LatLng(station.latitude, station.longitude),
                    width: 40,
                    height: 40,
                    alignment: Alignment.topCenter,
                    child: GestureDetector(
                      onTap: () => showStationDetailSheet(context, station.id),
                      child: const Icon(
                        Icons.location_on,
                        size: 40,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
              ],
            ),
            const _OsmAttribution(),
          ],
        ),
        if (stations.isEmpty)
          IgnorePointer(
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.canvasColor.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Belum ada stasiun',
                  style: context.textTheme.bodyMedium?.copyWith(color: AppTheme.primaryTextColor),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Attribution required by the OpenStreetMap tile usage policy.
class _OsmAttribution extends StatelessWidget {
  const _OsmAttribution();

  @override
  Widget build(BuildContext context) {
    return const RichAttributionWidget(
      alignment: AttributionAlignment.bottomRight,
      attributions: [TextSourceAttribution('OpenStreetMap contributors')],
    );
  }
}

class _MapPlaceholder extends StatelessWidget {
  final Widget child;

  const _MapPlaceholder({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(16),
      color: AppTheme.secondaryCanvasColor,
      child: Center(child: child),
    );
  }
}
