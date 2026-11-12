import 'booking.dart';

/// A fixed weekly booking: the same customer plays every [dayOfWeek] at the
/// same time (e.g. every Wednesday 20:00).
///
/// Occurrences are NOT stored — they are generated as confirmed manual
/// [Booking]s (with [Booking.recurringId] set) for whatever range is asked.
/// Cancelling one week adds that date to [skipped].
class RecurringBooking {
  const RecurringBooking({
    required this.id,
    required this.pitchId,
    required this.dayOfWeek,
    required this.startMinutes,
    required this.durationMinutes,
    required this.startDate,
    required this.price,
    this.customerName,
    this.skipped = const {},
  });

  final String id;
  final String pitchId;

  /// 0 = Sunday … 6 = Saturday.
  final int dayOfWeek;

  /// Minutes from midnight of the occurrence date (0 … 1439).
  final int startMinutes;
  final int durationMinutes;

  /// First date (00:00) the booking applies to.
  final DateTime startDate;

  /// Price of one occurrence in EGP.
  final int price;
  final String? customerName;

  /// Dates (00:00) cancelled for one week only.
  final Set<DateTime> skipped;

  /// The occurrence on [day] (a date), or null if there is none that day.
  Booking? occurrenceOn(DateTime day) {
    if (day.weekday % 7 != dayOfWeek ||
        day.isBefore(startDate) ||
        skipped.contains(day)) {
      return null;
    }
    final start = DateTime(day.year, day.month, day.day, 0, startMinutes);
    return Booking(
      id: occurrenceId(day),
      pitchId: pitchId,
      userId: null,
      startAt: start,
      endAt: start.add(Duration(minutes: durationMinutes)),
      source: BookingSource.manual,
      status: BookingStatus.confirmed,
      price: price,
      customerName: customerName,
      recurringId: id,
    );
  }

  /// Every occurrence overlapping [from, to).
  List<Booking> occurrencesBetween(DateTime from, DateTime to) {
    final result = <Booking>[];
    // Start a day early in case an occurrence runs past midnight.
    var day = DateTime(from.year, from.month, from.day - 1);
    while (day.isBefore(to)) {
      final b = occurrenceOn(day);
      if (b != null && b.overlaps(from, to)) result.add(b);
      day = DateTime(day.year, day.month, day.day + 1);
    }
    return result;
  }

  String occurrenceId(DateTime day) =>
      'rec_${id}_${day.year}-${day.month}-${day.day}';

  /// Reverses [occurrenceId] → (recurring id, date), or null.
  static (String, DateTime)? parseOccurrenceId(String bookingId) {
    final m = RegExp(r'^rec_(.+)_(\d+)-(\d+)-(\d+)$').firstMatch(bookingId);
    if (m == null) return null;
    return (
      m.group(1)!,
      DateTime(int.parse(m.group(2)!), int.parse(m.group(3)!),
          int.parse(m.group(4)!)),
    );
  }

  RecurringBooking copyWith({Set<DateTime>? skipped}) => RecurringBooking(
        id: id,
        pitchId: pitchId,
        dayOfWeek: dayOfWeek,
        startMinutes: startMinutes,
        durationMinutes: durationMinutes,
        startDate: startDate,
        price: price,
        customerName: customerName,
        skipped: skipped ?? this.skipped,
      );
}
