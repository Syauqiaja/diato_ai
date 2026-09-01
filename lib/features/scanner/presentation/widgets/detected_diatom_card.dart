import 'package:diato_ai/features/scanner/data/models/detected_diatom.dart';
import 'package:diato_ai/features/shared/widgets/spacings.dart';
import 'package:diato_ai/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class DetectedDiatomCard extends StatelessWidget {
  final DetectedDiatom diatom;
  final int number;

  const DetectedDiatomCard({
    super.key,
    required this.diatom,
    required this.number,
  });

  Color get _confidenceColor {
    final confidence = diatom.confidence;
    if (confidence >= 0.85) return Colors.green;
    if (confidence >= 0.70) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        initiallyExpanded: number == 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        leading: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: context.colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$number',
              style: context.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: Text(
          diatom.species,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colorScheme.primary,
          ),
        ),
        subtitle: Text(
          diatom.genus != null ? 'Genus ${diatom.genus}' : 'Diatom',
          style: context.textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: _confidenceColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            '${(diatom.confidence * 100).toInt()}%',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: _confidenceColor,
            ),
          ),
        ),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              vSpace(8),
              // Genus badge
              if (diatom.genus != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blue[300]!,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Genus ${diatom.genus}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[900],
                    ),
                  ),
                ),
              if (diatom.genus != null) vSpace(16),
              // Description, when the label resolved to a catalogue entry.
              if (diatom.description != null) ...[
                Text(
                  diatom.description!,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[700],
                  ),
                ),
                vSpace(16),
              ],
              // Confidence level
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.analytics,
                          color: context.colorScheme.primary,
                          size: 18,
                        ),
                        hSpace(6),
                        Text(
                          'Tingkat Kepercayaan',
                          style: context.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    vSpace(8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: diatom.confidence,
                        minHeight: 8,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _confidenceColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              vSpace(16),
              // Additional information. Hidden entirely when the species is not
              // in the catalogue yet, rather than showing a column of dashes.
              if (diatom.hasDetails) Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: context.colorScheme.primary,
                          size: 18,
                        ),
                        hSpace(6),
                        Text(
                          'Informasi Detail',
                          style: context.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    vSpace(12),
                    _buildInfoRow(context, 'Habitat', diatom.habitat),
                    vSpace(6),
                    _buildInfoRow(context, 'Ukuran', diatom.size),
                    vSpace(6),
                    _buildInfoRow(context, 'Bentuk', diatom.shape),
                    if (diatom.imageUrl != null) ...[
                      vSpace(12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          diatom.imageUrl!,
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String? value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: context.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
        ),
        hSpace(8),
        Expanded(
          child: Text(
            value ?? 'Belum tersedia',
            style: context.textTheme.bodySmall?.copyWith(
              color: value == null ? Colors.grey[500] : Colors.grey[800],
              fontStyle: value == null ? FontStyle.italic : FontStyle.normal,
            ),
          ),
        ),
      ],
    );
  }
}
