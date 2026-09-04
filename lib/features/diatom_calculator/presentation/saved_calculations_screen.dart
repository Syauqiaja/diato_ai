import 'package:diato_ai/core/di/injection.dart';
import 'package:diato_ai/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/saved_calculation.dart';
import 'diatom_result_screen.dart';
import '../domain/repositories/diatom_calculator_repository.dart';
import 'cubit/saved_calculations_cubit.dart';
import 'widgets/brdi_category_badge.dart';
import 'widgets/brdi_category_style.dart';
import 'widgets/calculation_date.dart';

/// Readings saved from this device.
///
/// They are kept against the device rather than an account, so a reinstall or
/// a second device starts with an empty list.
class SavedCalculationsScreen extends StatelessWidget {
  static const String routeName = 'saved_calculations';
  static const String routePath = 'saved';

  const SavedCalculationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          SavedCalculationsCubit(getIt<DiatomCalculatorRepository>())..load(),
      child: const _SavedCalculationsView(),
    );
  }
}

class _SavedCalculationsView extends StatelessWidget {
  const _SavedCalculationsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Perhitungan')),
      body: BlocBuilder<SavedCalculationsCubit, SavedCalculationsState>(
        builder: (context, state) {
          switch (state) {
            case SavedCalculationsInitial():
            case SavedCalculationsLoading():
              return const Center(child: CircularProgressIndicator());

            case SavedCalculationsError(:final message):
              return _Message(
                icon: Icons.cloud_off,
                text: message,
                onRetry: context.read<SavedCalculationsCubit>().load,
              );

            case SavedCalculationsLoaded(:final calculations):
              if (calculations.isEmpty) {
                return const _Message(
                  icon: Icons.science_outlined,
                  text: 'Belum ada perhitungan tersimpan.',
                );
              }

              return RefreshIndicator(
                onRefresh: context.read<SavedCalculationsCubit>().load,
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: calculations.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final calculation = calculations[index];
                    return Dismissible(
                      key: ValueKey(calculation.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: context.colorScheme.error,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.delete_outline,
                          color: context.colorScheme.onError,
                        ),
                      ),
                      confirmDismiss: (_) => _confirmDelete(context),
                      onDismissed: (_) async {
                        final messenger = ScaffoldMessenger.of(context);
                        final error = await context
                            .read<SavedCalculationsCubit>()
                            .delete(calculation.id);
                        if (error != null) {
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(error),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      child: _CalculationCard(
                        calculation: calculation,
                        onTap: () =>
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                builder: (_) => DiatomResultScreen.saved(
                                  calculation: calculation,
                                ),
                              ),
                            ),
                      ),
                    );
                  },
                ),
              );
          }
        },
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus perhitungan?'),
        content: const Text('Perhitungan ini akan dihapus permanen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }
}

class _CalculationCard extends StatelessWidget {
  final SavedCalculation calculation;
  final VoidCallback onTap;

  const _CalculationCard({required this.calculation, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final category = calculation.category;
    final scored = calculation.entries.where((e) => e.isScored).length;

    return Material(
      color: category?.background ?? context.colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          calculation.location ?? 'Tanpa nama lokasi',
                          style: context.textTheme.titleMedium?.copyWith(
                            color: category?.foreground,
                          ),
                        ),
                        if (calculation.createdAt != null)
                          Text(
                            formatCalculationDate(calculation.createdAt!),
                            style: context.textTheme.bodySmall?.copyWith(
                              color: category?.foreground.withValues(
                                alpha: 0.8,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        formatIndex(calculation.di),
                        style: context.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: category?.foreground,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (category != null)
                        BrdiCategoryBadge(category: category, dense: true),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                '${calculation.entries.length} spesies dicatat · $scored punya skor',
                style: context.textTheme.bodySmall?.copyWith(
                  color: category?.foreground,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final entry in calculation.entries)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${entry.speciesName} · ${entry.count}',
                        style: context.textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: entry.isScored ? null : Colors.grey[600],
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onRetry;

  const _Message({required this.icon, required this.text, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              text,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: onRetry,
                child: const Text('Coba lagi'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
