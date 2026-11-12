part of 'slot_picker_imports.dart';

/// Chosen day and slot for the slot picker.
class SlotPickerController {
  SlotPickerController(this.ref, this.pitchId) : day = ValueNotifier(_initialDay(ref));

  final WidgetRef ref;
  final String pitchId;
  final ValueNotifier<DateTime> day;
  final selected = ValueNotifier<TimeSlot?>(null);

  /// The day picked earlier (home / filters), never in the past.
  static DateTime _initialDay(WidgetRef ref) {
    final today = Fmt.dateOnly(DateTime.now());
    final chosen = ref.read(selectedDateProvider);
    return chosen.isBefore(today) ? today : chosen;
  }

  void selectDay(DateTime d) {
    day.value = d;
    selected.value = null;
    ref.read(selectedDateProvider.notifier).state = d;
  }

  void selectSlot(TimeSlot slot) => selected.value = slot;

  /// The selection, unless that slot got taken meanwhile — in that case the
  /// selection is dropped for good (after this frame, not during build).
  TimeSlot? validSelection(List<TimeSlot>? slots) {
    final s = selected.value;
    if (s == null || slots == null) return s;
    final still = slots.where((x) => x.startAt == s.startAt);
    if (still.isNotEmpty && still.first.isBookable) return s;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_disposed && selected.value == s) selected.value = null;
    });
    return null;
  }

  bool _disposed = false;

  void continueTo(BuildContext context, TimeSlot slot) =>
      context.push(Routes.confirmBooking, extra: slot);

  void dispose() {
    _disposed = true;
    day.dispose();
    selected.dispose();
  }
}
