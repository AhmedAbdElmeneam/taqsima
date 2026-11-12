part of 'slot_picker_widgets_imports.dart';

/// Grid of slot chips, or an empty state when closed / fully booked.
class SlotGrid extends StatelessWidget {
  const SlotGrid({
    super.key,
    required this.day,
    required this.slots,
    required this.selected,
    required this.onSelect,
  });

  final DateTime day;
  final List<TimeSlot> slots;
  final TimeSlot? selected;
  final ValueChanged<TimeSlot> onSelect;

  @override
  Widget build(BuildContext context) {
    if (slots.isEmpty) {
      return const EmptyState(
        icon: AppIcons.closed,
        title: S.closedThisDay,
        message: S.closedThisDayHint,
      );
    }
    if (!slots.any((s) => s.isBookable)) {
      return const EmptyState(
        icon: AppIcons.calendarX,
        title: S.noSlotsLeft,
        message: S.noSlotsLeftHint,
      );
    }
    return GridView.builder(
      // New key per day so the stagger replays when the day changes.
      key: ValueKey(day),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        mainAxisExtent: 64,
      ),
      itemCount: slots.length,
      itemBuilder: (_, i) {
        final s = slots[i];
        return FadeSlideIn(
          index: i,
          child: SlotChip(
            slot: s,
            selected: selected?.startAt == s.startAt,
            onTap: () => onSelect(s),
          ),
        );
      },
    );
  }
}
