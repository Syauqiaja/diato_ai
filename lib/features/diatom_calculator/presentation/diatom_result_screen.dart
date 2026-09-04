import 'package:diato_ai/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/theme.dart';
import '../../shared/widgets/spacings.dart';
import '../data/models/catalogue_species.dart';
import '../data/models/saved_calculation.dart';
import '../domain/brdi_calculator.dart';
import 'cubit/diatom_calculator_cubit.dart';
import 'widgets/brdi_category_style.dart';
import 'widgets/brdi_contribution_bars.dart';
import 'widgets/brdi_ring_gauge.dart';
import 'widgets/calculation_date.dart';

/// The result of one calculation, shown on its own screen.
///
/// The reading is taken once, when the screen opens, and held for as long as it
/// is on show: the animation is telling the user what the numbers behind them
/// came to, and a card that re-animated because a count changed underneath
/// would be describing a different sample than the one they asked about.
///
/// It opens two ways. The default constructor shows the reading the calculator
/// has just worked out, which can still be named and saved. [DiatomResultScreen.saved]
/// reopens a reading already stored: the same figures, but nothing left to
/// edit, so the location and the date are shown rather than asked for.
class DiatomResultScreen extends StatefulWidget {
  /// The stored reading being reopened, or null when this is a fresh one.
  final SavedCalculation? calculation;

  const DiatomResultScreen({super.key}) : calculation = null;

  const DiatomResultScreen.saved({super.key, required this.calculation});

  @override
  State<DiatomResultScreen> createState() => _DiatomResultScreenState();
}

class _DiatomResultScreenState extends State<DiatomResultScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );

  /// The reading this screen was opened to show, frozen at that moment.
  late final BrdiResult _result;
  late final BrdiCategory? _category;
  late final int _speciesCount;
  late final int _scoredCount;

  /// Only a fresh reading has a location left to write; a stored one has one.
  TextEditingController? _locationController;

  /// A stored reading is read only: there is nothing here left to save.
  bool get _isStored => widget.calculation != null;

  late final Animation<double> _ring = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.05, 0.75, curve: Curves.easeOutCubic),
  );

  late final Animation<double> _drop = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack),
  );

  late final Animation<double> _label = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.55, 0.85, curve: Curves.easeOut),
  );

  late final Animation<double> _sheet = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.6, 1.0, curve: Curves.easeOutCubic),
  );

  @override
  void initState() {
    super.initState();

    final stored = widget.calculation;
    if (stored != null) {
      _result = _resultOf(stored);
      // The band the server stored wins over the one the index falls in, so a
      // reopened reading says what it said when it was saved.
      _category = stored.category ?? _result.category;
      _speciesCount = stored.entries.length;
      _scoredCount = stored.entries.where((entry) => entry.isScored).length;
    } else {
      final state = context.read<DiatomCalculatorCubit>().state;
      _result = state.result;
      _category = state.result.category;
      _speciesCount = state.entries.length;
      _scoredCount = state.scoredCount;
      _locationController = TextEditingController(text: state.location);
    }

    _controller.forward();
  }

  /// The stored reading rebuilt into the shape the dial and the breakdown
  /// draw from. The index itself is the saved one rather than a fresh sum: it
  /// is what was recorded, and recomputing it could quietly disagree.
  static BrdiResult _resultOf(SavedCalculation calculation) {
    return BrdiResult(
      di: calculation.di,
      contributions: [
        for (final entry in calculation.entries)
          BrdiContribution(
            species: CatalogueSpecies(
              // A species dropped from the catalogue since leaves no id; the
              // breakdown only reads the name, so a placeholder is enough.
              id: entry.speciesId ?? -1,
              name: entry.speciesName,
              sensitivity: entry.sensitivity,
              indicator: entry.indicator,
            ),
            count: entry.count,
            sensitivity: entry.sensitivity ?? 0,
            indicator: entry.indicator ?? 0,
          ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _locationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final di = _result.di;
    final category = _category;

    // Nothing to show means the screen was opened on an empty reading, which
    // the calculator does not allow; bail out rather than draw a blank ring.
    if (di == null || category == null) {
      return const Scaffold(backgroundColor: AppTheme.primaryColor);
    }

    final body = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _Header(onBack: () => Navigator.of(context).pop()),
            if (_locationController case final controller?)
              _LocationField(controller: controller)
            else
              _LocationLabel(calculation: widget.calculation!),
            SizedBox(
              height: 300,
              child: Center(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) => _Dial(
                    di: di,
                    category: category,
                    ring: _ring.value,
                    drop: _drop.value,
                    label: _label.value,
                  ),
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _sheet,
              builder: (context, child) => Opacity(
                opacity: _sheet.value,
                child: Transform.translate(
                  offset: Offset(0, 60 * (1 - _sheet.value)),
                  child: child,
                ),
              ),
              child: _SummarySheet(
                result: _result,
                category: category,
                speciesCount: _speciesCount,
                scoredCount: _scoredCount,
                savedAt: widget.calculation?.createdAt,
                canSave: !_isStored,
              ),
            ),
            const SizedBox(height: kBotbarHeight),
          ],
        ),
      ),
    );

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: _isStored
          ? body
          : BlocListener<DiatomCalculatorCubit, DiatomCalculatorState>(
              listenWhen: (previous, current) =>
                  previous.saveStatus != current.saveStatus,
              listener: (context, state) {
                // The calculator screen owns the message and the reset; this
                // screen only has to get out of the way once it is stored.
                if (state.saveStatus == SaveStatus.saved) {
                  Navigator.of(context).pop();
                }
              },
              child: body,
            ),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onBack;

  const _Header({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const SizedBox(height: 56, width: double.infinity),
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            tooltip: 'Kembali',
          ),
        ),
        Text(
          'Kondisi Air',
          style: context.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

/// The sampling point, editable here so the reading can be labelled at the
/// moment it is looked at rather than before it exists.
class _LocationField extends StatelessWidget {
  final TextEditingController controller;

  const _LocationField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.16),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.my_location,
                size: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: controller,
                textAlign: TextAlign.center,
                onChanged: context.read<DiatomCalculatorCubit>().setLocation,
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  isDense: true,
                  // The app fills every field with a pale grey; inside this
                  // pill that reads as a second, misaligned box.
                  filled: false,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  hintText: 'Lokasi / stasiun, cth. Stasiun I Brantas',
                  hintStyle: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.65),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}

/// The same pill as [_LocationField], for a reading that is only being read
/// back: where it was taken, and when.
class _LocationLabel extends StatelessWidget {
  final SavedCalculation calculation;

  const _LocationLabel({required this.calculation});

  @override
  Widget build(BuildContext context) {
    final createdAt = calculation.createdAt;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.16),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.place_outlined,
                size: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    calculation.location ?? 'Tanpa nama lokasi',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (createdAt != null)
                    Text(
                      formatCalculationDate(createdAt),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}

/// The ring, the drop inside it and the band's name underneath.
class _Dial extends StatelessWidget {
  final double di;
  final BrdiCategory category;
  final double ring;
  final double drop;
  final double label;

  const _Dial({
    required this.di,
    required this.category,
    required this.ring,
    required this.drop,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    // The 1-5 scale mapped onto the ring, so a reading of 5 fills it entirely.
    final target = ((di - 1) / 4).clamp(0.0, 1.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BrdiRingGauge(
          progress: target * ring,
          color: category.onDark,
          child: Transform.scale(
            scale: drop.clamp(0.0, 1.5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.water_drop, size: 56, color: category.onDark),
                const SizedBox(height: 8),
                Text(
                  // Counting up with the ring keeps the number and the fill
                  // telling the same story while it lands.
                  formatIndex(1 + (di - 1) * ring),
                  style: context.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 28),
        Opacity(
          opacity: label,
          child: Text(
            category.label.toUpperCase(),
            style: context.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

/// What the number was built from, and the button that stores it.
class _SummarySheet extends StatelessWidget {
  final BrdiResult result;
  final BrdiCategory category;
  final int speciesCount;
  final int scoredCount;

  /// When the reading was stored, or null while it still only exists here.
  final DateTime? savedAt;

  /// A stored reading has nothing left to save, so the button is left off
  /// rather than shown doing nothing.
  final bool canSave;

  const _SummarySheet({
    required this.result,
    required this.category,
    required this.speciesCount,
    required this.scoredCount,
    required this.savedAt,
    required this.canSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.46,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _CategoryScale(current: category),
              const SizedBox(height: 24),
              _SummaryRow(label: 'Indeks BRDI', value: formatIndex(result.di!)),
              _SummaryRow(label: 'Spesies dihitung', value: '$speciesCount'),
              _SummaryRow(
                label: 'Spesies berskor',
                value: '$scoredCount dari $speciesCount',
              ),
              if (savedAt != null)
                _SummaryRow(
                  label: 'Disimpan',
                  value: formatCalculationDate(savedAt!),
                ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              _Detail(result: result),
              if (canSave) ...[
                const SizedBox(height: 20),
                BlocBuilder<DiatomCalculatorCubit, DiatomCalculatorState>(
                  buildWhen: (previous, current) =>
                      previous.saveStatus != current.saveStatus,
                  builder: (context, state) {
                    final saving = state.saveStatus == SaveStatus.saving;

                    return FilledButton(
                      onPressed: saving
                          ? null
                          : context.read<DiatomCalculatorCubit>().save,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.secondaryColor,
                        foregroundColor: AppTheme.primaryColor,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      child: saving
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(
                              'Simpan Perhitungan',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// The five bands in order, with the one this reading landed in raised out of
/// the row, so the result is read as a position on a scale.
class _CategoryScale extends StatelessWidget {
  final BrdiCategory current;

  const _CategoryScale({required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final category in BrdiCategory.values)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    height: 52,
                    decoration: BoxDecoration(
                      color: category.onDark.withValues(
                        alpha: category == current ? 1 : 0.35,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: category == current
                          ? Border.all(color: AppTheme.primaryColor, width: 2)
                          : null,
                    ),
                    child: const Icon(
                      Icons.water_drop,
                      size: 22,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category.shortLabel,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      height: 1.3,
                      fontWeight: category == current
                          ? FontWeight.w700
                          : FontWeight.w400,
                      color: category == current
                          ? AppTheme.primaryTextColor
                          : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: context.textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// The per-species breakdown, folded away so the summary stays short.
class _Detail extends StatefulWidget {
  final BrdiResult result;

  const _Detail({required this.result});

  @override
  State<_Detail> createState() => _DetailState();
}

class _DetailState extends State<_Detail> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: () => setState(() => _open = !_open),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Detail kontribusi spesies',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.primaryTextColor,
                  ),
                ),
                Icon(
                  _open ? Icons.expand_less : Icons.expand_more,
                  size: 20,
                  color: AppTheme.primaryTextColor,
                ),
              ],
            ),
          ),
        ),
        if (_open) BrdiContributionBars(result: widget.result),
      ],
    );
  }
}
