import 'package:diato_ai/core/di/injection.dart';
import 'package:diato_ai/features/shared/widgets/linear_line.dart';
import 'package:diato_ai/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/theme.dart';
import '../domain/repositories/diatom_calculator_repository.dart';
import 'cubit/diatom_calculator_cubit.dart';
import 'saved_calculations_screen.dart';
import 'widgets/brdi_result_card.dart';
import 'widgets/species_entry_tile.dart';
import 'widgets/species_search_field.dart';

/// The Brantas River Diatom Index calculator.
///
/// The species catalogue is fetched from the server, but the index is worked
/// out on the device: counts change and the number under them follows straight
/// away, with no round trip. Saving is what talks to the server.
class DiatomCalculatorScreen extends StatelessWidget {
  static const String routeName = 'diatom_calculator';
  static const String routePath = '/diatom-calculator';

  const DiatomCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          DiatomCalculatorCubit(getIt<DiatomCalculatorRepository>())
            ..loadCatalogue(),
      child: const _DiatomCalculatorView(),
    );
  }
}

class _DiatomCalculatorView extends StatefulWidget {
  const _DiatomCalculatorView();

  @override
  State<_DiatomCalculatorView> createState() => _DiatomCalculatorViewState();
}

class _DiatomCalculatorViewState extends State<_DiatomCalculatorView> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<DiatomCalculatorCubit, DiatomCalculatorState>(
          listenWhen: (previous, current) =>
              previous.saveStatus != current.saveStatus,
          listener: (context, state) {
            if (state.saveStatus == SaveStatus.saved) {
              _searchController.clear();
              _locationController.clear();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Perhitungan tersimpan'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              context.read<DiatomCalculatorCubit>().reset();
            } else if (state.saveStatus == SaveStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.saveError ?? 'Gagal menyimpan perhitungan'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          builder: (context, state) {
            final cubit = context.read<DiatomCalculatorCubit>();

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              children: [
                _Header(
                  onOpenSaved: () =>
                      context.pushNamed(SavedCalculationsScreen.routeName),
                ),
                const LinearLine(),
                const SizedBox(height: 16),

                if (state.catalogueStatus == CatalogueStatus.error)
                  _CatalogueError(
                    message: state.catalogueError,
                    onRetry: cubit.loadCatalogue,
                  )
                else ...[
                  SpeciesSearchField(
                    controller: _searchController,
                    suggestions: state.suggestions,
                    enabled: state.catalogueStatus == CatalogueStatus.loaded,
                    onQueryChanged: cubit.search,
                    onSelected: (species) {
                      cubit.addSpecies(species);
                      _searchController.clear();
                      FocusScope.of(context).unfocus();
                    },
                  ),
                  const SizedBox(height: 8),

                  if (state.entries.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        'Belum ada spesies ditambahkan. Cari dan pilih dari daftar di atas.',
                        textAlign: TextAlign.center,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    )
                  else
                    for (final entry in state.entries)
                      SpeciesEntryTile(
                        key: ValueKey(entry.species.id),
                        entry: entry,
                        onCountChanged: (count) =>
                            cubit.updateCount(entry.species.id, count),
                        onRemove: () => cubit.removeSpecies(entry.species.id),
                      ),

                  if (state.entries.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${state.scoredCount} dari ${state.entries.length} spesies ikut dihitung.',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),
                  BrdiResultCard(result: state.result),
                  const SizedBox(height: 20),

                  TextField(
                    controller: _locationController,
                    onChanged: cubit.setLocation,
                    decoration: InputDecoration(
                      labelText: 'Lokasi / stasiun (opsional)',
                      hintText: 'Contoh: Stasiun I, Sungai Brantas',
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: state.hasResult &&
                            state.saveStatus != SaveStatus.saving
                        ? cubit.save
                        : null,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: state.saveStatus == SaveStatus.saving
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Simpan perhitungan'),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onOpenSaved;

  const _Header({required this.onOpenSaved});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BRDI',
                style: context.textTheme.displayMedium?.copyWith(
                  color: AppTheme.primaryTextColor,
                ),
              ),
              Text(
                'Brantas River Diatom Indeks',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.primaryTextColor,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onOpenSaved,
          tooltip: 'Riwayat perhitungan',
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: context.colorScheme.secondary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.history,
              color: context.colorScheme.primary,
              size: 28,
            ),
          ),
        ),
      ],
    );
  }
}

class _CatalogueError extends StatelessWidget {
  final String? message;
  final VoidCallback onRetry;

  const _CatalogueError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Icon(Icons.cloud_off, size: 40, color: Colors.grey[500]),
          const SizedBox(height: 12),
          Text(
            message ?? 'Gagal memuat daftar spesies',
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(onPressed: onRetry, child: const Text('Coba lagi')),
        ],
      ),
    );
  }
}
