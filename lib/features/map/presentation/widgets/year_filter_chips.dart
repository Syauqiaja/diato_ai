import 'package:flutter/material.dart';

/// Horizontal "Semua / 1998 / 2008 / ..." chips for picking a sampling year.
/// Renders nothing when there are no years to pick from.
class YearFilterChips extends StatelessWidget {
  final List<int> years;
  final int? selectedYear;
  final ValueChanged<int?> onSelected;

  const YearFilterChips({
    super.key,
    required this.years,
    required this.selectedYear,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (years.isEmpty) return const SizedBox.shrink();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          FilterChip(
            label: const Text('Semua'),
            selected: selectedYear == null,
            onSelected: (_) => onSelected(null),
          ),
          for (final year in years) ...[
            const SizedBox(width: 8),
            FilterChip(
              label: Text('$year'),
              selected: selectedYear == year,
              onSelected: (selected) => onSelected(selected ? year : null),
            ),
          ],
        ],
      ),
    );
  }
}
