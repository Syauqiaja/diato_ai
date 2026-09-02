import 'package:diato_ai/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/brdi_calculator.dart';

/// One counted species: the name, how many were found, and a way to drop it.
///
/// The count field keeps its own controller so typing is not interrupted by the
/// index recomputing on every keystroke.
class SpeciesEntryTile extends StatefulWidget {
  final SpeciesEntry entry;
  final ValueChanged<int> onCountChanged;
  final VoidCallback onRemove;

  const SpeciesEntryTile({
    super.key,
    required this.entry,
    required this.onCountChanged,
    required this.onRemove,
  });

  @override
  State<SpeciesEntryTile> createState() => _SpeciesEntryTileState();
}

class _SpeciesEntryTileState extends State<SpeciesEntryTile> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.entry.count.toString(),
  );

  @override
  void didUpdateWidget(covariant SpeciesEntryTile oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Only follow a count changed from elsewhere; rewriting the field while the
    // user is typing in it would fight the cursor.
    final incoming = widget.entry.count.toString();
    if (widget.entry.count != oldWidget.entry.count &&
        _controller.text != incoming) {
      _controller.text = incoming;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final species = widget.entry.species;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  species.name,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (species.isScored) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Sensitivitas ${species.sensitivity} · indikator ${species.indicator}',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 64,
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textAlign: TextAlign.right,
              onChanged: (value) =>
                  widget.onCountChanged(int.tryParse(value) ?? 0),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: widget.onRemove,
            icon: const Icon(Icons.delete_outline, size: 20),
            tooltip: 'Hapus ${species.name}',
            color: Colors.grey[600],
          ),
        ],
      ),
    );
  }
}
