import 'blocked_slot.dart';
import 'booking.dart';

enum SlotState { available, appBooked, manualBooked, blocked }

/// A COMPUTED slot (never stored): working hours minus bookings minus blocks.
class TimeSlot {
  const TimeSlot({
    required this.pitchId,
    required this.startAt,
    required this.endAt,
    required this.state,
    required this.price,
    required this.isPast,
    this.booking,
    this.blockedSlot,
  });

  final String pitchId;
  final DateTime startAt;
  final DateTime endAt;
  final SlotState state;
  final int price;
  final bool isPast;
  final Booking? booking;
  final BlockedSlot? blockedSlot;

  bool get isBookable => state == SlotState.available && !isPast;

  Duration get duration => endAt.difference(startAt);
}
