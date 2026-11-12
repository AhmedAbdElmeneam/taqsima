part of 'weekly_calendar_imports.dart';

/// Week paging and slot-type filter for the owner calendar.
class WeeklyCalendarController {
  /// How many weeks ahead the owner can page (about a year).
  static const maxWeekOffset = 52;

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

  /// Opens a month calendar; the week holding the picked day is shown.
  Future<void> pickDate(BuildContext context) async {
    final today = todayDate();
    final picked = await showDatePicker(
      context: context,
      initialDate: weekStart,
      firstDate: today,
      lastDate: today.add(const Duration(days: 7 * maxWeekOffset + 6)),
      helpText: S.pickDate,
    );
    if (picked == null || _disposed) return;
    weekOffset.value = Fmt.dateOnly(picked).difference(today).inDays ~/ 7;
  }

  /// Tapping the active chip again clears it.
  void toggleFilter(SlotState? state) =>
      filter.value = filter.value == state ? null : state;

  void tapSlot(BuildContext context, TimeSlot slot) =>
      onOwnerSlotTap(context, slot);

  bool _disposed = false;

  void dispose() {
    _disposed = true;
    weekOffset.dispose();
    filter.dispose();
  }
}
