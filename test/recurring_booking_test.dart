import 'package:flutter_test/flutter_test.dart';
import 'package:ma3adna/data/mock/mock_db.dart';
import 'package:ma3adna/data/mock/mock_repositories.dart';
import 'package:ma3adna/data/models/models.dart';
import 'package:ma3adna/data/repositories/repositories.dart';

void main() {
  group('RecurringBooking', () {
    final rule = RecurringBooking(
      id: 'r1',
      pitchId: 'p1',
      dayOfWeek: 3, // Wednesday
      startMinutes: 20 * 60,
      durationMinutes: 60,
      startDate: DateTime(2026, 11, 11), // a Wednesday
      price: 300,
      customerName: 'فريق الأربعاء',
      skipped: {DateTime(2026, 11, 25)},
    );

    test('occurs every Wednesday from the start date, except skipped', () {
      final list =
          rule.occurrencesBetween(DateTime(2026, 11, 1), DateTime(2026, 12, 3));
      expect(list.map((b) => b.startAt), [
        DateTime(2026, 11, 11, 20),
        DateTime(2026, 11, 18, 20),
        DateTime(2026, 12, 2, 20),
      ]);
      expect(list.every((b) => b.recurringId == 'r1'), isTrue);
    });

    test('occurrence ids round-trip', () {
      final day = DateTime(2026, 12, 2);
      expect(RecurringBooking.parseOccurrenceId(rule.occurrenceId(day)),
          ('r1', day));
      expect(RecurringBooking.parseOccurrenceId('b1001'), isNull);
    });
  });

  group('MockBookingRepository fixed bookings', () {
    late MockDb db;
    late MockBookingRepository repo;
    late String pitchId;
    late DateTime start;

    setUp(() {
      db = MockDb();
      repo = MockBookingRepository(db);
      pitchId = db.pitches.first.id;
      // Far enough ahead that the seed data has nothing there.
      final d = DateTime.now().add(const Duration(days: 60));
      start = DateTime(d.year, d.month, d.day, 23);
    });

    test('blocks the same time every week and can skip one week', () async {
      final end = start.add(const Duration(hours: 1));
      final rule = await repo.createRecurringBooking(
          pitchId: pitchId, startAt: start, endAt: end, customerName: 'x');

      final nextWeek = start.add(const Duration(days: 7));
      final week2 = DateTime(nextWeek.year, nextWeek.month, nextWeek.day, 23);
      final found = await repo.bookingsForPitch(pitchId,
          from: week2, to: week2.add(const Duration(hours: 1)));
      expect(found.single.recurringId, rule.id);

      // Players can't book it…
      await expectLater(
        repo.createBooking(
            pitchId: pitchId,
            userId: 'u1',
            startAt: week2,
            endAt: week2.add(const Duration(hours: 1)),
            source: BookingSource.app),
        throwsA(isA<SlotUnavailableException>()),
      );

      // …until the owner cancels that week only.
      await repo.deleteBooking(found.single.id);
      expect(
          await repo.bookingsForPitch(pitchId,
              from: week2, to: week2.add(const Duration(hours: 1))),
          isEmpty);

      // A second fixed booking at the same weekly time is refused.
      await expectLater(
        repo.createRecurringBooking(
            pitchId: pitchId,
            startAt: week2,
            endAt: week2.add(const Duration(hours: 1))),
        throwsA(isA<SlotUnavailableException>()),
      );

      await repo.deleteRecurringBooking(rule.id);
      expect(db.recurring, isEmpty);
    });
  });
}
