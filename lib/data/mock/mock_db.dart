import 'dart:math' as math;

import '../models/models.dart';
import '../services/slot_service.dart';

/// In-memory "database" shared by all mock repositories, so the player side
/// and the owner side always see the same state during a session.
class MockDb {
  MockDb({DateTime? now}) {
    _seed(now ?? DateTime.now());
  }

  final users = <AppUser>[];
  final pitches = <Pitch>[];
  final workingHours = <WorkingHours>[];
  final bookings = <Booking>[];
  final blocked = <BlockedSlot>[];

  int _seq = 1000;
  String nextId(String prefix) => '$prefix${_seq++}';

  // Demo identities used by the mock login.
  static const demoPlayerId = 'u1';
  static const demoOwnerId = 'o1';

  void _seed(DateTime now) {
    users.addAll(const [
      AppUser(
          id: 'u1',
          name: 'أحمد علي',
          phone: '01012345678',
          role: UserRole.player),
      AppUser(
          id: 'u2',
          name: 'محمد حسن',
          phone: '01122334455',
          role: UserRole.player),
      AppUser(
          id: 'u3',
          name: 'كريم مصطفى',
          phone: '01233445566',
          role: UserRole.player),
      AppUser(
          id: 'u4',
          name: 'يوسف إبراهيم',
          phone: '01544556677',
          role: UserRole.player),
      AppUser(
          id: 'u5',
          name: 'عمر خالد',
          phone: '01066778899',
          role: UserRole.player),
      AppUser(
          id: 'u6',
          name: 'مصطفى سعيد',
          phone: '01188990011',
          role: UserRole.player),
      AppUser(
          id: 'o1',
          name: 'الحاج محمود عبد العزيز',
          phone: '01001234567',
          role: UserRole.owner),
      AppUser(
          id: 'o2',
          name: 'م. شريف كمال',
          phone: '01111234567',
          role: UserRole.owner),
      AppUser(
          id: 'o3',
          name: 'كابتن هشام فؤاد',
          phone: '01221234567',
          role: UserRole.owner),
      AppUser(
          id: 'o4',
          name: 'عادل منصور',
          phone: '01551234567',
          role: UserRole.owner),
      AppUser(
          id: 'o5',
          name: 'سامح جرجس',
          phone: '01091234567',
          role: UserRole.owner),
    ]);

    const all = Amenity.values;
    pitches.addAll(const [
      Pitch(
          id: 'p1',
          ownerId: 'o1',
          name: 'ملعب النجوم',
          area: 'مدينة نصر',
          description:
              'ملعب خماسي نجيل صناعي جديد، جنب نادي السكة، إضاءة LED قوية ومكان انتظار واسع.',
          lat: 30.056,
          lng: 31.330,
          type: PitchType.fiveASide,
          pricePerHour: 350,
          photos: ['p1a', 'p1b', 'p1c'],
          amenities: all,
          status: PitchStatus.active),
      Pitch(
          id: 'p2',
          ownerId: 'o2',
          name: 'ستاد الشباب',
          area: 'المعادي',
          description:
              'ملعب سباعي مقاس كبير على الكورنيش، مناسب للدوريات والماتشات الكبيرة.',
          lat: 29.960,
          lng: 31.257,
          type: PitchType.sevenASide,
          pricePerHour: 600,
          photos: ['p2a', 'p2b'],
          amenities: all,
          status: PitchStatus.active),
      Pitch(
          id: 'p3',
          ownerId: 'o3',
          name: 'ملعب الكابتن',
          area: 'التجمع الخامس',
          description:
              'ملعب خماسي في قلب التجمع، قريب من شارع التسعين، فيه كافيتريا.',
          lat: 30.008,
          lng: 31.430,
          type: PitchType.fiveASide,
          pricePerHour: 450,
          photos: ['p3a', 'p3b'],
          amenities: [
            Amenity.artificialGrass,
            Amenity.lighting,
            Amenity.parking
          ],
          status: PitchStatus.active),
      Pitch(
          id: 'p4',
          ownerId: 'o4',
          name: 'أرينا زايد',
          area: 'الشيخ زايد',
          description: 'ملعب سباعي مغطى جزئياً، نجيل صناعي درجة أولى وغرف لبس.',
          lat: 30.040,
          lng: 30.985,
          type: PitchType.sevenASide,
          pricePerHour: 700,
          photos: ['p4a', 'p4b', 'p4c'],
          amenities: all,
          status: PitchStatus.active),
      Pitch(
          id: 'p5',
          ownerId: 'o2',
          name: 'ملعب الصفوة',
          area: 'المهندسين',
          description: 'ملعب خماسي هادي في شارع جانبي من جامعة الدول.',
          lat: 30.058,
          lng: 31.200,
          type: PitchType.fiveASide,
          pricePerHour: 400,
          photos: ['p5a'],
          amenities: [
            Amenity.artificialGrass,
            Amenity.lighting,
            Amenity.toilets
          ],
          status: PitchStatus.active),
      Pitch(
          id: 'p6',
          ownerId: 'o3',
          name: 'ملعب الريان',
          area: 'مصر الجديدة',
          description: 'ملعب خماسي بسعر حلو، قريب من ميدان الحجاز.',
          lat: 30.091,
          lng: 31.322,
          type: PitchType.fiveASide,
          pricePerHour: 300,
          photos: ['p6a', 'p6b'],
          amenities: [Amenity.artificialGrass, Amenity.lighting],
          status: PitchStatus.active),
      Pitch(
          id: 'p7',
          ownerId: 'o4',
          name: 'ملعب الهدف',
          area: '6 أكتوبر',
          description: 'ملعب سباعي واسع في الحي المتميز، باركينج كبير.',
          lat: 29.972,
          lng: 30.945,
          type: PitchType.sevenASide,
          pricePerHour: 500,
          photos: ['p7a'],
          amenities: [
            Amenity.artificialGrass,
            Amenity.lighting,
            Amenity.parking
          ],
          status: PitchStatus.active),
      Pitch(
          id: 'p8',
          ownerId: 'o5',
          name: 'ملعب فيصل الرياضي',
          area: 'فيصل',
          description: 'ملعب خماسي اقتصادي، على بعد دقيقتين من محطة المترو.',
          lat: 30.010,
          lng: 31.170,
          type: PitchType.fiveASide,
          pricePerHour: 250,
          photos: ['p8a'],
          amenities: [
            Amenity.artificialGrass,
            Amenity.lighting,
            Amenity.toilets
          ],
          status: PitchStatus.active),
      Pitch(
          id: 'p9',
          ownerId: 'o1',
          name: 'ملعب الأبطال',
          area: 'مدينة نصر',
          description: 'ملعب سباعي جديد في الحي العاشر.',
          lat: 30.045,
          lng: 31.360,
          type: PitchType.sevenASide,
          pricePerHour: 550,
          photos: ['p9a'],
          amenities: [Amenity.artificialGrass, Amenity.lighting],
          status: PitchStatus.pending),
      Pitch(
          id: 'p10',
          ownerId: 'o5',
          name: 'ملعب الواحة',
          area: 'المعادي',
          description: 'ملعب خماسي وسط الشجر في دجلة، جو هادي ومريح.',
          lat: 29.955,
          lng: 31.275,
          type: PitchType.fiveASide,
          pricePerHour: 320,
          photos: ['p10a', 'p10b'],
          amenities: all,
          status: PitchStatus.active),
    ]);

    // Working hours: (from, to, duration). Friday opens earlier.
    const schedule = {
      'p1': (900, 60, 60),
      'p2': (960, 120, 90),
      'p3': (960, 120, 60),
      'p4': (900, 0, 90),
      'p5': (960, 60, 60),
      'p6': (960, 0, 60),
      'p7': (960, 60, 90),
      'p8': (900, 0, 60),
      'p9': (960, 60, 90),
      'p10': (960, 60, 60),
    };
    schedule.forEach((pitchId, s) {
      for (var d = 0; d < 7; d++) {
        workingHours.add(WorkingHours(
          pitchId: pitchId,
          dayOfWeek: d,
          from: d == 5 ? 840 : s.$1,
          to: s.$2,
          slotDurationMinutes: s.$3,
        ));
      }
    });

    final today = DateTime(now.year, now.month, now.day);
    DateTime at(int dayOffset, int hour, [int minute = 0]) =>
        today.add(Duration(days: dayOffset, hours: hour, minutes: minute));

    Pitch pitch(String id) => pitches.firstWhere((p) => p.id == id);

    void book(
        String pitchId, String? userId, DateTime start, BookingStatus status,
        {BookingSource source = BookingSource.app,
        String? customer,
        int? minutes}) {
      final p = pitch(pitchId);
      final dur = minutes ??
          workingHours
              .firstWhere((w) => w.pitchId == pitchId)
              .slotDurationMinutes;
      bookings.add(Booking(
        id: nextId('b'),
        pitchId: pitchId,
        userId: userId,
        startAt: start,
        endAt: start.add(Duration(minutes: dur)),
        source: source,
        status: status,
        price: SlotService.priceFor(p, dur),
        customerName: customer,
      ));
    }

    // Demo player's own bookings.
    book('p1', 'u1', at(1, 21), BookingStatus.confirmed);
    book('p3', 'u1', at(2, 20), BookingStatus.pending);
    book('p2', 'u1', at(-3, 19), BookingStatus.completed);
    book('p1', 'u1', at(-6, 18), BookingStatus.cancelled);
    book('p5', 'u1', at(-10, 20), BookingStatus.completed);

    // Demo owner (p1) — today and upcoming requests.
    book('p1', 'u2', at(0, 17), BookingStatus.confirmed);
    book('p1', null, at(0, 19), BookingStatus.confirmed,
        source: BookingSource.manual, customer: 'كابتن سيد');
    book('p1', 'u3', at(0, 20), BookingStatus.pending);
    book('p1', 'u4', at(0, 22), BookingStatus.confirmed);
    blocked.add(BlockedSlot(
        id: nextId('x'),
        pitchId: 'p1',
        startAt: at(0, 23),
        endAt: at(0, 24),
        reason: 'صيانة الإضاءة'));
    book('p1', 'u5', at(1, 18), BookingStatus.pending);
    book('p1', 'u6', at(1, 19), BookingStatus.pending);
    book('p1', 'u2', at(3, 20), BookingStatus.pending);
    book('p1', 'u4', at(2, 21), BookingStatus.confirmed);

    _seedRandom(now, today);
  }

  /// Fills the surrounding two weeks with realistic random occupancy.
  void _seedRandom(DateTime now, DateTime today) {
    final rnd = math.Random(42);
    const slots = SlotService();
    const players = ['u2', 'u3', 'u4', 'u5', 'u6'];
    const customers = [
      'عم رضا',
      'شباب الجامعة',
      'أستاذ وليد',
      'كابتن أشرف',
      null
    ];
    const reasons = ['صيانة', 'تدريب أكاديمية', null];

    for (final p in pitches.where((p) => p.status == PitchStatus.active)) {
      for (var offset = -7; offset <= 7; offset++) {
        final day = today.add(Duration(days: offset));
        final grid = slots.slotsForDay(
          pitch: p,
          workingHours: workingHours,
          day: day,
          bookings: bookings,
          blocked: blocked,
          now: now,
        );
        // Busier at night and on weekends (Thu/Fri).
        final weekend =
            day.weekday == DateTime.thursday || day.weekday == DateTime.friday;
        for (final s in grid) {
          if (s.state != SlotState.available) continue;
          final night = s.startAt.hour >= 19 || s.startAt.hour < 2;
          final chance = (p.id == 'p1' ? .25 : .4) +
              (night ? .2 : 0) +
              (weekend ? .1 : 0) -
              (offset > 3 ? .2 : 0);
          if (rnd.nextDouble() > chance) continue;

          final kind = rnd.nextDouble();
          final past = s.endAt.isBefore(now);
          if (kind < .06) {
            blocked.add(BlockedSlot(
                id: nextId('x'),
                pitchId: p.id,
                startAt: s.startAt,
                endAt: s.endAt,
                reason: reasons[rnd.nextInt(reasons.length)]));
          } else if (kind < .3) {
            bookings.add(Booking(
                id: nextId('b'),
                pitchId: p.id,
                userId: null,
                startAt: s.startAt,
                endAt: s.endAt,
                source: BookingSource.manual,
                status:
                    past ? BookingStatus.completed : BookingStatus.confirmed,
                price: s.price,
                customerName: customers[rnd.nextInt(customers.length)]));
          } else {
            final pending = !past && p.id != 'p1' && kind > .9;
            bookings.add(Booking(
                id: nextId('b'),
                pitchId: p.id,
                userId: players[rnd.nextInt(players.length)],
                startAt: s.startAt,
                endAt: s.endAt,
                source: BookingSource.app,
                status: past
                    ? BookingStatus.completed
                    : pending
                        ? BookingStatus.pending
                        : BookingStatus.confirmed,
                price: s.price));
          }
        }
      }
    }
  }
}
