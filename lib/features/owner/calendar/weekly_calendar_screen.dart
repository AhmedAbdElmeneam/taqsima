import 'package:flutter/material.dart';
import 'package:ma3adna/core/theme/app_spacing.dart';
import 'package:ma3adna/core/theme/app_icons.dart';
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

  /// null = show every slot type.
  SlotState? _filter;

  @override
  Widget build(BuildContext context) {
    final pitch = ref.watch(currentOwnerPitchProvider);
    final t = Theme.of(context).textTheme;
    final start = todayDate().add(Duration(days: 7 * _weekOffset));
    final end = start.add(const Duration(days: 6));

    return TabPage(
      child: AsyncView(
        value: pitch,
        builder: (p) {
          if (p == null) {
            return const EmptyState(icon: AppIcons.pitch, title: S.noPitchYet);
          }
          final week = ref.watch(weekSlotsProvider((p.id, start)));
          // One vertical scroll for the whole screen (title, week, filter, grid).
          return ListView(
            padding: const EdgeInsets.only(bottom: AppSpacing.navBarClearance),
            children: [
              const PageTitle(S.weeklyCalendar,
                  padding: EdgeInsets.fromLTRB(20, 12, 20, 0)),
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
                      icon: const Icon(AppIcons.backward),
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
                      icon: const Icon(AppIcons.forward),
                    ),
                  ],
                ),
              ),
              AsyncView(
                value: week,
                builder: (days) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _FilterBar(
                      days: days,
                      selected: _filter,
                      onSelected: (f) => setState(() => _filter = f),
                    ),
                    _WeekGrid(days: days, start: start, filter: _filter),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Filter chips: الكل / متاح / محجوز / حجز يدوي / مغلق, each with its count.
class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.days,
    required this.selected,
    required this.onSelected,
  });

  final List<List<TimeSlot>> days;
  final SlotState? selected;
  final ValueChanged<SlotState?> onSelected;

  @override
  Widget build(BuildContext context) {
    final all = days.expand((d) => d).where((s) => !s.isPast).toList();
    int count(SlotState? st) =>
        st == null ? all.length : all.where((s) => s.state == st).length;

    Widget chip(SlotState? st, String label) {
      final isOn = selected == st;
      final color = st?.color ?? AppColors.ink;
      return Padding(
        padding: const EdgeInsetsDirectional.only(end: 8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: isOn
                ? (st?.background ?? AppColors.primaryLight)
                : AppColors.card,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
                color: isOn ? color.withOpacity(.6) : AppColors.borderSoft),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () => onSelected(isOn && st != null ? null : st),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (st == null)
                    Icon(AppIcons.funnel, size: 16, color: color)
                  else
                    Icon(st.icon, size: 16, color: color),
                  const SizedBox(width: 6),
                  Text(
                    S.filterCount(label, count(st)),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isOn ? color : AppColors.ink,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
        children: [
          chip(null, S.filterAll),
          for (final st in SlotState.values) chip(st, st.label),
        ],
      ),
    );
  }
}

class _WeekGrid extends ConsumerWidget {
  const _WeekGrid({required this.days, required this.start, this.filter});
  final List<List<TimeSlot>> days;
  final DateTime start;
  final SlotState? filter;

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
      return const EmptyState(icon: AppIcons.closed, title: S.closedThisDay);
    }

    // Only scrolls sideways; the page itself scrolls vertically.
    return Padding(
      padding: EdgeInsets.zero,
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
                        color: isToday ? AppColors.primary : AppColors.card,
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
                            : _FilteredCell(
                                visible: filter == null ||
                                    maps[i][offset]!.state == filter,
                                child: SlotChip(
                                  slot: maps[i][offset]!,
                                  ownerView: true,
                                  subtitle: _subtitle(maps[i][offset]!),
                                  onTap: () => onOwnerSlotTap(
                                      context, ref, maps[i][offset]!),
                                ),
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
    return _subtitleFor(s);
  }
}

/// Dims (and disables) cells hidden by the filter, with a short fade + shrink.
class _FilteredCell extends StatelessWidget {
  const _FilteredCell({required this.visible, required this.child});
  final bool visible;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !visible,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 220),
        opacity: visible ? 1 : .12,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          scale: visible ? 1 : .92,
          child: child,
        ),
      ),
    );
  }
}

String? _subtitleFor(TimeSlot s) {
  final b = s.booking;
  if (b != null && b.status == BookingStatus.pending) return b.status.label;
  if (s.state == SlotState.manualBooked) {
    return b?.customerName ?? S.manualBooking;
  }
  return null;
}
