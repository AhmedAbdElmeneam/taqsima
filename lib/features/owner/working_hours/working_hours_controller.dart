part of 'working_hours_imports.dart';

/// Editable opening hours per weekday + slot duration.
class WorkingHoursController {
  WorkingHoursController(this.ref, this.pitchId, List<WorkingHours> initial)
      : days = ValueNotifier({
          for (var d = 0; d < 7; d++)
            d: () {
              final w = initial.where((w) => w.dayOfWeek == d).firstOrNull;
              return DayHours(
                  open: w != null, from: w?.from ?? 960, to: w?.to ?? 0);
            }(),
        }),
        duration =
            ValueNotifier(initial.firstOrNull?.slotDurationMinutes ?? 60);

  final WidgetRef ref;
  final String pitchId;

  /// Egyptian week order: Saturday first.
  static const order = [6, 0, 1, 2, 3, 4, 5];
  static const durations = [60, 90];

  final ValueNotifier<Map<int, DayHours>> days;
  final ValueNotifier<int> duration;
  final saving = ValueNotifier(false);

  bool _disposed = false;

  late final Listenable changes = Listenable.merge([days, duration, saving]);

  void _update(int day, DayHours value) =>
      days.value = {...days.value, day: value};

  void setOpen(int day, bool open) =>
      _update(day, days.value[day]!.copyWith(open: open));

  void setDuration(int minutes) => duration.value = minutes;

  /// Picks a time every 30 min. "To" may run past midnight (until 04:00).
  Future<void> pickTime(BuildContext context, int day,
      {required bool isFrom}) async {
    final d = days.value[day]!;
    final options = [
      for (var m = isFrom ? 6 * 60 : 8 * 60;
          m <= (isFrom ? 23 * 60 : 28 * 60);
          m += 30)
        m,
    ];
    final current = isFrom ? d.from : (d.to <= d.from ? d.to + 1440 : d.to);
    final picked = await showAppBottomSheet<int>(
      context,
      title: isFrom ? S.from : S.to,
      builder: (_) => TimeOptionsSheet(options: options, current: current),
    );
    if (picked == null || _disposed) return;
    final latest = days.value[day]!;
    _update(
        day,
        isFrom
            ? latest.copyWith(from: picked)
            : latest.copyWith(to: picked % 1440));
  }

  Future<void> save(BuildContext context) async {
    saving.value = true;
    try {
      final hours = [
        for (final e in days.value.entries)
          if (e.value.open)
            WorkingHours(
              pitchId: pitchId,
              dayOfWeek: e.key,
              from: e.value.from,
              to: e.value.to,
              slotDurationMinutes: duration.value,
            ),
      ];
      await ref.read(pitchRepositoryProvider).saveWorkingHours(pitchId, hours);
      ref.refreshData();
      if (!context.mounted) return;
      showSnack(context, S.hoursSaved);
      context.pop();
    } finally {
      if (!_disposed) saving.value = false;
    }
  }

  void dispose() {
    _disposed = true;
    days.dispose();
    duration.dispose();
    saving.dispose();
  }
}
