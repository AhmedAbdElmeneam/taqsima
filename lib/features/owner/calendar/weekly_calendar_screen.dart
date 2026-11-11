import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/labels.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/models.dart';
import '../dashboard/pitch_switcher.dart';
import '../owner_providers.dart';
import 'slot_action_sheet.dart';

/// Week grid: columns = days, rows = slot start times, every cell color-coded.
class WeeklyCalendarScreen extends ConsumerStatefulWidget {
  const WeeklyCalendarScreen({super.key});

  @override
  ConsumerState<WeeklyCalendarScreen> createState() =>
      _WeeklyCalendarScreenState();
}

class _WeeklyCalendarScreenState extends ConsumerState<WeeklyCalendarScreen> {
  int _weekOffset = 0;

  @override
  Widget build(BuildContext context) {
    final pitch = ref.watch(currentOwnerPitchProvider);
    final t = Theme.of(context).textTheme;
    final start = todayDate().add(Duration(days: 7 * _weekOffset));
    final end = start.add(const Duration(days: 6));

    return Scaffold(
      appBar: AppBar(title: const Text(S.weeklyCalendar)),
      body: AsyncView(
        value: pitch,
        builder: (p) {
          if (p == null) {
            return const EmptyState(
                icon: Icons.stadium_outlined, title: S.noPitchYet);
          }
          final week = ref.watch(weekSlotsProvider((p.id, start)));
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: PitchSwitcher(pitch: p),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
                child: Row(
                  children: [
                    IconButton.outlined(
                      onPressed: _weekOffset == 0
                          ? null
                          : () => setState(() => _weekOffset--),
                      icon: const Icon(Icons.chevron_right_rounded),
                    ),
                    Expanded(
                      child: Text(
                        '${start.day} ${S.months[start.month - 1]} - ${end.day} ${S.months[end.month - 1]}',
                        textAlign: TextAlign.center,
                        style: t.titleMedium,
                      ),
                    ),
                    IconButton.outlined(
                      onPressed: _weekOffset >= 3
                          ? null
                          : () => setState(() => _weekOffset++),
                      icon: const Icon(Icons.chevron_left_rounded),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 4, 20, 10),
                child: SlotLegend(states: SlotState.values),
              ),
              Expanded(
                child: AsyncView(
                  value: week,
                  builder: (days) => _WeekGrid(days: days, start: start),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _WeekGrid extends ConsumerWidget {
  const _WeekGrid({required this.days, required this.start});
  final List<List<TimeSlot>> days;
  final DateTime start;

  static const _cellW = 84.0;
  static const _cellH = 54.0;
  static const _timeW = 64.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    // Rows = union of slot start offsets (minutes from that day's midnight).
    final rows = <int>{};
    final maps = <Map<int, TimeSlot>>[];
    for (var i = 0; i < days.length; i++) {
      final dayStart = start.add(Duration(days: i));
      final m = <int, TimeSlot>{};
      for (final s in days[i]) {
        final offset = s.startAt.difference(dayStart).inMinutes;
        m[offset] = s;
        rows.add(offset);
      }
      maps.add(m);
    }
    final sorted = rows.toList()..sort();
    final today = todayDate();

    if (sorted.isEmpty) {
      return const EmptyState(
          icon: Icons.door_front_door_outlined, title: S.closedThisDay);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row: days.
            Row(
              children: [
                const SizedBox(width: _timeW),
                for (var i = 0; i < 7; i++)
                  Builder(builder: (_) {
                    final d = start.add(Duration(days: i));
                    final isToday = Fmt.isSameDay(d, today);
                    return Container(
                      width: _cellW,
                      margin: const EdgeInsets.all(2),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: isToday ? AppColors.primary : AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          Text(
                            isToday
                                ? S.today
                                : S.weekdaysShort[Fmt.dayOfWeek(d)],
                            style: t.bodySmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: isToday
                                    ? Colors.white
                                    : AppColors.inkMuted),
                          ),
                          Text('${d.day}',
                              style: t.titleMedium?.copyWith(
                                  color:
                                      isToday ? Colors.white : AppColors.ink)),
                        ],
                      ),
                    );
                  }),
              ],
            ),
            for (final offset in sorted)
              Row(
                children: [
                  SizedBox(
                    width: _timeW,
                    child: Text(Fmt.minutesOfDay(offset),
                        style: t.bodySmall?.copyWith(
                            fontWeight: FontWeight.w700, color: AppColors.ink)),
                  ),
                  for (var i = 0; i < 7; i++)
                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: SizedBox(
                        width: _cellW,
                        height: _cellH,
                        child: maps[i][offset] == null
                            ? DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppColors.background,
                                ),
                              )
                            : SlotChip(
                                slot: maps[i][offset]!,
                                ownerView: true,
                                subtitle: _subtitle(maps[i][offset]!),
                                onTap: () => onOwnerSlotTap(
                                    context, ref, maps[i][offset]!),
                              ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  String? _subtitle(TimeSlot s) {
    final b = s.booking;
    if (b != null && b.status == BookingStatus.pending) return b.status.label;
    if (s.state == SlotState.manualBooked) {
      return b?.customerName ?? S.manualBooking;
    }
    return null;
  }
}
