part of 'weekly_calendar_imports.dart';

/// Week paging and slot-type filter for the owner calendar.
class WeeklyCalendarController {
  /// How many weeks ahead the owner can page.
  static const maxWeekOffset = 3;

  final weekOffset = ValueNotifier(0);

  /// null = show every slot type.
  final filter = ValueNotifier<SlotState?>(null);

  DateTime get weekStart =>
      todayDate().add(Duration(days: 7 * weekOffset.value));

  DateTime get weekEnd => weekStart.add(const Duration(days: 6));

  bool get canGoBack => weekOffset.value > 0;
  bool get canGoForward => weekOffset.value < maxWeekOffset;

  void previousWeek() {
    if (canGoBack) weekOffset.value--;
  }

  void nextWeek() {
    if (canGoForward) weekOffset.value++;
  }

  /// Tapping the active chip again clears it.
  void toggleFilter(SlotState? state) =>
      filter.value = filter.value == state ? null : state;

  void tapSlot(BuildContext context, TimeSlot slot) =>
      onOwnerSlotTap(context, slot);

  void dispose() {
    weekOffset.dispose();
    filter.dispose();
  }
}
