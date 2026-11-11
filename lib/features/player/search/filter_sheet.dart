import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/labels.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/models.dart';
import '../../../data/providers.dart';
import '../../../data/repositories/repositories.dart';
import '../player_providers.dart';

/// Opens the filters sheet. Returns true when the player applied filters.
Future<bool> showFilterSheet(BuildContext context) async {
  final applied = await showAppBottomSheet<bool>(
    context,
    title: S.filters,
    builder: (_) => const _FilterSheet(),
  );
  return applied ?? false;
}

class _FilterSheet extends ConsumerStatefulWidget {
  const _FilterSheet();

  @override
  ConsumerState<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends ConsumerState<_FilterSheet> {
  static const _prices = [300, 400, 500, 700];
  late PitchFilter _filter = ref.read(searchFilterProvider);
  late DateTime _date = ref.read(selectedDateProvider);

  @override
  Widget build(BuildContext context) {
    final areas = ref.watch(areasProvider).valueOrNull ?? const [];
    final today = Fmt.dateOnly(DateTime.now());
    final t = Theme.of(context).textTheme;

    Widget label(String s) => Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Text(s, style: t.titleMedium),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        label(S.date),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (var i = 0; i < 5; i++)
              _choice(
                Fmt.dayRelative(today.add(Duration(days: i))),
                Fmt.isSameDay(_date, today.add(Duration(days: i))),
                () => setState(() => _date = today.add(Duration(days: i))),
              ),
          ],
        ),
        label(S.area),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _choice(
                S.anyArea,
                _filter.area == null,
                () => setState(
                    () => _filter = _filter.copyWith(area: () => null))),
            for (final a in areas)
              _choice(
                  a,
                  _filter.area == a,
                  () => setState(
                      () => _filter = _filter.copyWith(area: () => a))),
          ],
        ),
        label(S.pitchType),
        Wrap(
          spacing: 8,
          children: [
            _choice(
                S.anyType,
                _filter.type == null,
                () => setState(
                    () => _filter = _filter.copyWith(type: () => null))),
            for (final type in PitchType.values)
              _choice(
                  type.label,
                  _filter.type == type,
                  () => setState(
                      () => _filter = _filter.copyWith(type: () => type))),
          ],
        ),
        label(S.maxPrice),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _choice(
                S.anyPrice,
                _filter.maxPrice == null,
                () => setState(
                    () => _filter = _filter.copyWith(maxPrice: () => null))),
            for (final p in _prices)
              _choice(
                  S.price(p),
                  _filter.maxPrice == p,
                  () => setState(
                      () => _filter = _filter.copyWith(maxPrice: () => p))),
          ],
        ),
        const SizedBox(height: 24),
        PrimaryButton(
          label: S.applyFilters,
          onPressed: () {
            ref.read(searchFilterProvider.notifier).state = _filter;
            ref.read(selectedDateProvider.notifier).state = _date;
            Navigator.pop(context, true);
          },
        ),
        TextButton(
          onPressed: () => setState(() {
            _filter = PitchFilter(query: _filter.query);
            _date = today;
          }),
          child: const Text(S.resetFilters),
        ),
      ],
    );
  }

  Widget _choice(String label, bool selected, VoidCallback onTap) => ChoiceChip(
        label: Text(label),
        selected: selected,
        showCheckmark: false,
        onSelected: (_) => onTap(),
        labelStyle: TextStyle(
          color: selected ? AppColors.primaryDark : AppColors.ink,
          fontWeight: FontWeight.w700,
        ),
        side: BorderSide(
            color: selected ? AppColors.primary : AppColors.border, width: 1.5),
      );
}
