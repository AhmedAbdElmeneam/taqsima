part of 'owner_dashboard_widgets_imports.dart';

/// "Today's bookings" header + one row per slot.
class TodayTimeline extends StatelessWidget {
  const TodayTimeline({
    super.key,
    required this.slots,
    required this.onOpenCalendar,
    required this.onSlotTap,
  });

  final List<TimeSlot> slots;
  final VoidCallback onOpenCalendar;
  final ValueChanged<TimeSlot> onSlotTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          title: S.todaysBookings,
          action: S.navCalendar,
          onAction: onOpenCalendar,
        ),
        Text(S.tapFreeSlotHint, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 10),
        if (slots.isEmpty)
          const EmptyState(icon: AppIcons.closed, title: S.closedThisDay)
        else
          for (final (i, s) in slots.indexed)
            FadeSlideIn(
              index: i,
              child: TodaySlotRow(slot: s, onTap: () => onSlotTap(s)),
            ),
      ],
    );
  }
}
