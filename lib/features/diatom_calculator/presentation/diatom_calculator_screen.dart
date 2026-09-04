import 'package:diato_ai/core/di/injection.dart';
import 'package:diato_ai/features/shared/widgets/linear_line.dart';
import 'package:diato_ai/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/theme.dart';
import '../domain/repositories/diatom_calculator_repository.dart';
import 'cubit/diatom_calculator_cubit.dart';
import 'diatom_result_screen.dart';
import 'saved_calculations_screen.dart';
import 'widgets/species_entry_tile.dart';
import 'widgets/species_search_field.dart';

/// The Brantas River Diatom Index calculator.
///
/// The species catalogue is fetched from the server, but the index is worked
/// out on the device. The number is kept off this screen until the user asks
/// for it: counting is the work, and a figure that shifted with every keystroke
/// would be read as a result before the sample was finished. Pressing
/// "Lakukan Perhitungan" opens the reading on [DiatomResultScreen], where it is
/// also saved.
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Opens the result on its own screen, carrying the same cubit across so the
  /// reading shown there is the one the counts on this screen produced.
  ///
  /// It goes on the root navigator: the result is meant to fill the screen, and
  /// the shell's bottom bar would otherwise sit over the save button.
  void _openResult(BuildContext context, DiatomCalculatorCubit cubit) {
    FocusScope.of(context).unfocus();

    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: cubit,
          child: const DiatomResultScreen(),
        ),
      ),
    );
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
                      '${state.scoredCount} dari ${state.entries.length} spesies punya skor.',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: state.hasResult
                        ? () => _openResult(context, cubit)
                        : null,
                    icon: const Icon(Icons.calculate_outlined),
                    label: const Text('Lakukan Perhitungan'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
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
