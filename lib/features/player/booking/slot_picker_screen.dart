import 'package:flutter/material.dart';
import 'package:ma3adna/core/theme/app_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_strings.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/models.dart';
import '../../../data/providers.dart';
import '../player_providers.dart';

/// THE key screen: pick a day on top, then tap one free slot.
class SlotPickerScreen extends ConsumerStatefulWidget {
  const SlotPickerScreen({super.key, required this.pitchId});
  final String pitchId;

  @override
  ConsumerState<SlotPickerScreen> createState() => _SlotPickerScreenState();
}

class _SlotPickerScreenState extends ConsumerState<SlotPickerScreen> {
  late DateTime _day = _initialDay();
  TimeSlot? _selected;

  DateTime _initialDay() {
    final today = Fmt.dateOnly(DateTime.now());
    final chosen = ref.read(selectedDateProvider);
    return chosen.isBefore(today) ? today : chosen;
  }

  @override
  Widget build(BuildContext context) {
    final pitch = ref.watch(pitchProvider(widget.pitchId)).valueOrNull;
    final slots = ref.watch(daySlotsProvider((widget.pitchId, _day)));
    final t = Theme.of(context).textTheme;

    // If the selected slot got taken meanwhile, drop the selection.
    final current = slots.valueOrNull;
    if (_selected != null && current != null) {
      final still = current.where((s) => s.startAt == _selected!.startAt);
      if (still.isEmpty || !still.first.isBookable) _selected = null;
    }

    return Scaffold(
      appBar: AppBar(title: const Text(S.chooseTime)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (pitch != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Row(
                children: [
                  SizedBox(
                    width: 52,
                    height: 52,
                    child: PitchImage(
                      photoKey:
                          pitch.photos.isEmpty ? pitch.id : pitch.photos.first,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(pitch.name, style: t.titleMedium),
                        Text(
                            '${pitch.area} • ${S.pricePerHour(pitch.pricePerHour)}',
                            style: t.bodyMedium
                                ?.copyWith(color: AppColors.inkMuted)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: Text(S.chooseDay, style: t.titleMedium),
          ),
          DaySelector(
            selected: _day,
            onSelected: (d) => setState(() {
              _day = d;
              _selected = null;
              ref.read(selectedDateProvider.notifier).state = d;
            }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
            child: Row(
              children: [
                Expanded(child: Text(S.availableTimes, style: t.titleMedium)),
                const SlotLegend(
                    states: [SlotState.available, SlotState.blocked],
                    playerView: true),
              ],
            ),
          ),
          Expanded(
            child: AsyncView(
              value: slots,
              builder: (list) {
                if (list.isEmpty) {
                  return const EmptyState(
                    icon: AppIcons.closed,
                    title: S.closedThisDay,
                    message: S.closedThisDayHint,
                  );
                }
                if (!list.any((s) => s.isBookable)) {
                  return const EmptyState(
                    icon: AppIcons.calendarX,
                    title: S.noSlotsLeft,
                    message: S.noSlotsLeftHint,
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    mainAxisExtent: 64,
                  ),
                  itemCount: list.length,
                  itemBuilder: (_, i) {
                    final s = list[i];
                    return SlotChip(
                      slot: s,
                      selected: _selected?.startAt == s.startAt,
                      onTap: () => setState(() => _selected = s),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomActionBar(
        child: Row(
          children: [
            Expanded(
              child: _selected == null
                  ? Text(S.selectSlotFirst,
                      style: t.bodyLarge?.copyWith(color: AppColors.inkMuted))
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            Fmt.timeRange(_selected!.startAt, _selected!.endAt),
                            style: t.titleMedium),
                        Text(
                            '${Fmt.duration(_selected!.duration)} • ${S.price(_selected!.price)}',
                            style: t.bodyMedium?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 150,
              child: PrimaryButton(
                label: S.continueBtn,
                onPressed: _selected == null
                    ? null
                    : () =>
                        context.push(Routes.confirmBooking, extra: _selected),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
