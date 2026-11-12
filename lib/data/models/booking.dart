enum BookingSource { app, manual }

enum BookingStatus { pending, confirmed, cancelled, completed }

class Booking {
  const Booking({
    required this.id,
    required this.pitchId,
    required this.userId,
    required this.startAt,
    required this.endAt,
    required this.source,
    required this.status,
    required this.price,
    this.customerName,
    this.recurringId,
  });

  final String id;
  final String pitchId;

  /// Null for manual bookings entered by the owner.
  final String? userId;
  final DateTime startAt;
  final DateTime endAt;
  final BookingSource source;
  final BookingStatus status;

  /// Total price in EGP.
  final int price;

  /// Optional name the owner typed for a manual booking.
  final String? customerName;

  /// Set when this is one week of a fixed weekly booking.
  final String? recurringId;

  bool get isRecurring => recurringId != null;

  /// Whether this booking occupies its time slot.
  bool get occupiesSlot => status != BookingStatus.cancelled;

  Duration get duration => endAt.difference(startAt);

  bool overlaps(DateTime start, DateTime end) =>
      startAt.isBefore(end) && endAt.isAfter(start);

  Booking copyWith({BookingStatus? status}) => Booking(
        id: id,
        pitchId: pitchId,
        userId: userId,
        startAt: startAt,
        endAt: endAt,
        source: source,
        status: status ?? this.status,
        price: price,
        customerName: customerName,
        recurringId: recurringId,
      );
}
