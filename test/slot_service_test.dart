import 'package:flutter_test/flutter_test.dart';
import 'package:ma3adna/data/models/models.dart';
import 'package:ma3adna/data/services/slot_service.dart';

void main() {
  const pitch = Pitch(
    id: 'p',
    ownerId: 'o',
    name: 'n',
    description: '',
    area: 'a',
    lat: 0,
    lng: 0,
    type: PitchType.fiveASide,
    pricePerHour: 300,
    photos: [],
    amenities: [],
    status: PitchStatus.active,
  );
  final day = DateTime(2026, 11, 12); // Thursday → dayOfWeek 4
  final now = DateTime(2026, 11, 1);

  List<TimeSlot> run(List<WorkingHours> hours,
          {List<Booking> bookings = const [],
          List<BlockedSlot> blocked = const []}) =>
      const SlotService().slotsForDay(
          pitch: pitch,
          workingHours: hours,
          day: day,
          bookings: bookings,
          blocked: blocked,
          now: now);

  test('closed day returns no slots', () {
    expect(run(const []), isEmpty);
  });

  test('hours past midnight and 90-minute slots', () {
    final slots = run(const [
      WorkingHours(
          pitchId: 'p',
          dayOfWeek: 4,
          from: 960,
          to: 120,
          slotDurationMinutes: 90),
    ]);
    // 16:00 → 02:00 = 600 min → 6 full 90-min slots.
    expect(slots.length, 6);
    expect(slots.last.endAt, DateTime(2026, 11, 13, 1));
    expect(slots.first.price, 450);
  });

  test('bookings and blocks subtract from availability', () {
    final slots = run(
      const [
        WorkingHours(
            pitchId: 'p',
            dayOfWeek: 4,
            from: 1080,
            to: 1320,
            slotDurationMinutes: 60),
      ],
      bookings: [
        Booking(
            id: 'b1',
            pitchId: 'p',
            userId: 'u',
            startAt: DateTime(2026, 11, 12, 18),
            endAt: DateTime(2026, 11, 12, 19),
            source: BookingSource.app,
            status: BookingStatus.confirmed,
            price: 300),
        Booking(
            id: 'b2',
            pitchId: 'p',
            userId: null,
            startAt: DateTime(2026, 11, 12, 19),
            endAt: DateTime(2026, 11, 12, 20),
            source: BookingSource.manual,
            status: BookingStatus.confirmed,
            price: 300),
        Booking(
            id: 'b3',
            pitchId: 'p',
            userId: 'u',
            startAt: DateTime(2026, 11, 12, 21),
            endAt: DateTime(2026, 11, 12, 22),
            source: BookingSource.app,
            status: BookingStatus.cancelled,
            price: 300),
      ],
      blocked: [
        BlockedSlot(
            id: 'x',
            pitchId: 'p',
            startAt: DateTime(2026, 11, 12, 20),
            endAt: DateTime(2026, 11, 12, 21)),
      ],
    );
    expect(slots.map((s) => s.state), [
      SlotState.appBooked,
      SlotState.manualBooked,
      SlotState.blocked,
      SlotState.available, // cancelled booking frees the slot
    ]);
  });
}
