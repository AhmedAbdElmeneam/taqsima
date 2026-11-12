part of 'weekly_calendar_widgets_imports.dart';

/// Filter chips: all / free / booked / manual / blocked, each with its count
/// (upcoming slots only).
class CalendarFilterBar extends StatelessWidget {
  const CalendarFilterBar({
    super.key,
    required this.days,
    required this.selected,
    required this.onSelected,
  });

  final List<List<TimeSlot>> days;
  final SlotState? selected;
  final ValueChanged<SlotState?> onSelected;

  @override
  Widget build(BuildContext context) {
    final upcoming = days.expand((d) => d).where((s) => !s.isPast).toList();
    int count(SlotState? st) => st == null
        ? upcoming.length
        : upcoming.where((s) => s.state == st).length;

    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
        children: [
          CalendarFilterChip(
            state: null,
            label: S.filterAll,
            count: count(null),
            selected: selected == null,
            onTap: () => onSelected(null),
          ),
          for (final st in SlotState.values)
            CalendarFilterChip(
              state: st,
              label: st.label,
              count: count(st),
              selected: selected == st,
              onTap: () => onSelected(st),
            ),
        ],
      ),
    );
  }
}
