import '../models/models.dart';

/// THE single place where available slots are computed:
///   slots = working hours − bookings − blocked slots.
///
/// Slots are never stored. This class is pure (no I/O) so it can move to the
/// backend later unchanged in behaviour.
class SlotService {
  const SlotService();

  /// Generates every slot for [day] (local date) and tags it with its state.
  ///
  /// [bookings] and [blocked] should cover [day] and the early hours of the
  /// next day (pitches may close after midnight).
  List<TimeSlot> slotsForDay({
    required Pitch pitch,
    required List<WorkingHours> workingHours,
    required DateTime day,
    required List<Booking> bookings,
    required List<BlockedSlot> blocked,
    DateTime? now,
  }) {
    final dow = day.weekday % 7;
    final hours = workingHours
        .where((w) => w.pitchId == pitch.id && w.dayOfWeek == dow)
        .toList();
    if (hours.isEmpty) return const [];

    final clock = now ?? DateTime.now();
    final midnight = DateTime(day.year, day.month, day.day);
    final result = <TimeSlot>[];

    for (final wh in hours) {
      final step = wh.slotDurationMinutes;
      for (var m = wh.from; m + step <= wh.endMinutes; m += step) {
        final start = midnight.add(Duration(minutes: m));
        final end = start.add(Duration(minutes: step));

        Booking? booking;
        for (final b in bookings) {
          if (b.pitchId == pitch.id && b.occupiesSlot && b.overlaps(start, end)) {
            booking = b;
            break;
          }
        }
        BlockedSlot? block;
        if (booking == null) {
          for (final bl in blocked) {
            if (bl.pitchId == pitch.id && bl.overlaps(start, end)) {
              block = bl;
              break;
            }
          }
        }

        final state = booking != null
            ? (booking.source == BookingSource.app
                ? SlotState.appBooked
                : SlotState.manualBooked)
            : block != null
                ? SlotState.blocked
                : SlotState.available;

        result.add(TimeSlot(
          pitchId: pitch.id,
          startAt: start,
          endAt: end,
          state: state,
          price: priceFor(pitch, step),
          isPast: start.isBefore(clock),
          booking: booking,
          blockedSlot: block,
        ));
      }
    }
    result.sort((a, b) => a.startAt.compareTo(b.startAt));
    return result;
  }

  /// Whether [start, end) is free (no active booking, no block).
  bool isFree({
    required String pitchId,
    required DateTime start,
    required DateTime end,
    required List<Booking> bookings,
    required List<BlockedSlot> blocked,
  }) {
    final booked = bookings.any(
        (b) => b.pitchId == pitchId && b.occupiesSlot && b.overlaps(start, end));
    final isBlocked =
        blocked.any((b) => b.pitchId == pitchId && b.overlaps(start, end));
    return !booked && !isBlocked;
  }

  static int priceFor(Pitch pitch, int minutes) =>
      (pitch.pricePerHour * minutes / 60).round();
}
