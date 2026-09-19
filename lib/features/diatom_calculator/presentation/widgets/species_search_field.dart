import 'package:diato_ai/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

import '../../data/models/catalogue_species.dart';

/// Search over the catalogue, with matches offered directly beneath the field.
///
/// Species without scores are offered too, and labelled: they are part of the
/// sample even though they carry no weight in the index.
class SpeciesSearchField extends StatelessWidget {
  final TextEditingController controller;
  final List<CatalogueSpecies> suggestions;
  final bool enabled;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<CatalogueSpecies> onSelected;

  const SpeciesSearchField({
    super.key,
    required this.controller,
    required this.suggestions,
    required this.enabled,
    required this.onQueryChanged,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: controller,
          enabled: enabled,
          onChanged: onQueryChanged,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: enabled
                ? 'Cari nama spesies...'
                : 'Memuat daftar spesies...',
            prefixIcon: const Icon(Icons.search, size: 20),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        if (suggestions.isNotEmpty) ...[
          const SizedBox(height: 6),
          Material(
            color: context.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            clipBehavior: Clip.antiAlias,
            elevation: 1,
            child: Column(
              children: [
                for (final species in suggestions)
                  InkWell(
                    onTap: () => onSelected(species),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              species.name,
                              style: context.textTheme.bodyMedium?.copyWith(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
