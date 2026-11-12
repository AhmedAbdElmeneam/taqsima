part of 'weekly_calendar_widgets_imports.dart';

/// 7 day columns × slot-time rows. Scrolls sideways only; the page itself
/// scrolls vertically.
class WeekGrid extends StatelessWidget {
  const WeekGrid({
    super.key,
    required this.days,
    required this.start,
    required this.filter,
    required this.onSlotTap,
  });

  final List<List<TimeSlot>> days;
  final DateTime start;
  final SlotState? filter;
  final ValueChanged<TimeSlot> onSlotTap;

  static const _cellW = 84.0;
  static const _cellH = 54.0;
  static const _timeW = 64.0;

  /// Pending requests and manual customer names show under the time.
  static String? _subtitle(TimeSlot s) {
    final b = s.booking;
    if (b != null && b.status == BookingStatus.pending) return b.status.label;
    if (s.state == SlotState.manualBooked) {
      return b?.customerName ?? S.manualBooking;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
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

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(width: _timeW),
              for (var i = 0; i < 7; i++)
                WeekDayHeader(
                  day: start.add(Duration(days: i)),
                  isToday: Fmt.isSameDay(start.add(Duration(days: i)), today),
                  width: _cellW,
                ),
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
                      child: _cell(maps.length > i ? maps[i][offset] : null),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _cell(TimeSlot? slot) {
    if (slot == null) {
      return DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          color: AppColors.background,
        ),
      );
    }
    return FilteredCell(
      visible: filter == null || slot.state == filter,
      child: SlotChip(
        slot: slot,
        ownerView: true,
        subtitle: _subtitle(slot),
        onTap: () => onSlotTap(slot),
      ),
    );
  }
}
