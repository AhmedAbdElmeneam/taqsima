/// Opening hours for one weekday. A day with no [WorkingHours] row is closed.
///
/// [from] and [to] are minutes from midnight. If [to] <= [from] the pitch
/// closes after midnight (e.g. from 16:00 to 02:00 next day).
class WorkingHours {
  const WorkingHours({
    required this.pitchId,
    required this.dayOfWeek,
    required this.from,
    required this.to,
    required this.slotDurationMinutes,
  });

  final String pitchId;

  /// 0 = Sunday … 6 = Saturday.
  final int dayOfWeek;
  final int from;
  final int to;

  /// 60 or 90.
  final int slotDurationMinutes;

  bool get closesNextDay => to <= from;

  /// End in minutes from the start of [dayOfWeek] (may exceed 1440).
  int get endMinutes => closesNextDay ? to + 24 * 60 : to;

  WorkingHours copyWith({int? from, int? to, int? slotDurationMinutes}) =>
      WorkingHours(
        pitchId: pitchId,
        dayOfWeek: dayOfWeek,
        from: from ?? this.from,
        to: to ?? this.to,
        slotDurationMinutes: slotDurationMinutes ?? this.slotDurationMinutes,
      );
}
