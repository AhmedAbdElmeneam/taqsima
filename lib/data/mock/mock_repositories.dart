import '../models/models.dart';
import '../repositories/repositories.dart';
import '../services/slot_service.dart';
import 'mock_db.dart';

/// Simulated network latency so loading states are visible.
Future<void> _latency([int ms = 250]) =>
    Future.delayed(Duration(milliseconds: ms));

class MockAuthRepository implements AuthRepository {
  MockAuthRepository(this._db);
  final MockDb _db;

  @override
  Future<void> requestOtp(String phone) => _latency(600);

  @override
  Future<AppUser> verifyOtp({
    required String phone,
    required String code,
    required UserRole role,
    String? name,
  }) async {
    await _latency(700);
    if (!RegExp(r'^\d{4}$').hasMatch(code)) {
      throw const FormatException('invalid code');
    }
    // Demo: every player logs in as u1 and every owner as o1, so there is
    // always realistic data to look at.
    final id =
        role == UserRole.owner ? MockDb.demoOwnerId : MockDb.demoPlayerId;
    final i = _db.users.indexWhere((u) => u.id == id);
    final trimmed = name?.trim();
    final user = _db.users[i].copyWith(
      phone: phone,
      name: trimmed == null || trimmed.isEmpty ? null : trimmed,
    );
    _db.users[i] = user;
    return user;
  }

  @override
  Future<void> signOut() => _latency(150);
}

class MockUserRepository implements UserRepository {
  MockUserRepository(this._db);
  final MockDb _db;

  @override
  Future<AppUser?> getUser(String id) async {
    await _latency(100);
    return _db.users.where((u) => u.id == id).firstOrNull;
  }

  @override
  Future<AppUser> updateName(String id, String name) async {
    await _latency();
    final i = _db.users.indexWhere((u) => u.id == id);
    _db.users[i] = _db.users[i].copyWith(name: name);
    return _db.users[i];
  }
}

class MockPitchRepository implements PitchRepository {
  MockPitchRepository(this._db);
  final MockDb _db;

  @override
  Future<List<Pitch>> searchPitches(PitchFilter f) async {
    await _latency();
    final q = f.query?.trim();
    return _db.pitches.where((p) {
      if (p.status != PitchStatus.active) return false;
      if (q != null &&
          q.isNotEmpty &&
          !p.name.contains(q) &&
          !p.area.contains(q)) {
        return false;
      }
      if (f.area != null && p.area != f.area) return false;
      if (f.type != null && p.type != f.type) return false;
      if (f.maxPrice != null && p.pricePerHour > f.maxPrice!) return false;
      return true;
    }).toList();
  }

  @override
  Future<List<String>> areas() async {
    await _latency(50);
    return _db.pitches
        .where((p) => p.status == PitchStatus.active)
        .map((p) => p.area)
        .toSet()
        .toList();
  }

  @override
  Future<Pitch?> getPitch(String id) async {
    await _latency(150);
    return _db.pitches.where((p) => p.id == id).firstOrNull;
  }

  @override
  Future<List<Pitch>> pitchesForOwner(String ownerId) async {
    await _latency();
    return _db.pitches.where((p) => p.ownerId == ownerId).toList();
  }

  @override
  Future<Pitch> savePitch(Pitch pitch) async {
    await _latency(500);
    if (pitch.id.isEmpty) {
      final created = Pitch(
        id: _db.nextId('p'),
        ownerId: pitch.ownerId,
        name: pitch.name,
        description: pitch.description,
        area: pitch.area,
        lat: pitch.lat,
        lng: pitch.lng,
        type: pitch.type,
        pricePerHour: pitch.pricePerHour,
        photos: pitch.photos,
        amenities: pitch.amenities,
        status: PitchStatus.pending,
      );
      _db.pitches.add(created);
      // Default hours so the new pitch has a schedule to edit.
      for (var d = 0; d < 7; d++) {
        _db.workingHours.add(WorkingHours(
            pitchId: created.id,
            dayOfWeek: d,
            from: 960,
            to: 0,
            slotDurationMinutes: 60));
      }
      return created;
    }
    final i = _db.pitches.indexWhere((p) => p.id == pitch.id);
    _db.pitches[i] = pitch;
    return pitch;
  }

  @override
  Future<List<WorkingHours>> workingHours(String pitchId) async {
    await _latency(150);
    return _db.workingHours.where((w) => w.pitchId == pitchId).toList();
  }

  @override
  Future<void> saveWorkingHours(
      String pitchId, List<WorkingHours> hours) async {
    await _latency(400);
    _db.workingHours
      ..removeWhere((w) => w.pitchId == pitchId)
      ..addAll(hours);
  }
}

class MockBookingRepository implements BookingRepository {
  MockBookingRepository(this._db);
  final MockDb _db;
  static const _slots = SlotService();

  /// Stored bookings plus the fixed weekly ones generated for [from, to).
  List<Booking> _bookingsBetween(String pitchId, DateTime from, DateTime to) => [
        ..._db.bookings
            .where((b) => b.pitchId == pitchId && b.overlaps(from, to)),
        for (final r in _db.recurring.where((r) => r.pitchId == pitchId))
          ...r.occurrencesBetween(from, to),
      ];

  bool _isFree(String pitchId, DateTime start, DateTime end) => _slots.isFree(
      pitchId: pitchId,
      start: start,
      end: end,
      bookings: _bookingsBetween(pitchId, start, end),
      blocked: _db.blocked);

  /// Index of the fixed booking + the date, when [bookingId] is one week of it.
  (int, DateTime)? _occurrence(String bookingId) {
    final parsed = RecurringBooking.parseOccurrenceId(bookingId);
    if (parsed == null) return null;
    final i = _db.recurring.indexWhere((r) => r.id == parsed.$1);
    return i < 0 ? null : (i, parsed.$2);
  }

  void _skip(int index, DateTime day) {
    final r = _db.recurring[index];
    _db.recurring[index] = r.copyWith(skipped: {...r.skipped, day});
  }

  @override
  Future<List<Booking>> bookingsForPitch(String pitchId,
      {required DateTime from, required DateTime to}) async {
    await _latency(150);
    return _bookingsBetween(pitchId, from, to);
  }

  @override
  Future<List<Booking>> bookingsForUser(String userId) async {
    await _latency();
    return _db.bookings.where((b) => b.userId == userId).toList()
      ..sort((a, b) => a.startAt.compareTo(b.startAt));
  }

  @override
  Future<List<Booking>> bookingsForOwner(String ownerId,
      {BookingStatus? status}) async {
    await _latency();
    final ids =
        _db.pitches.where((p) => p.ownerId == ownerId).map((p) => p.id).toSet();
    return _db.bookings
        .where((b) =>
            ids.contains(b.pitchId) && (status == null || b.status == status))
        .toList()
      ..sort((a, b) => a.startAt.compareTo(b.startAt));
  }

  @override
  Future<Booking?> getBooking(String id) async {
    await _latency(150);
    final occ = _occurrence(id);
    if (occ != null) return _db.recurring[occ.$1].occurrenceOn(occ.$2);
    return _db.bookings.where((b) => b.id == id).firstOrNull;
  }

  @override
  Future<Booking> createBooking({
    required String pitchId,
    required String? userId,
    required DateTime startAt,
    required DateTime endAt,
    required BookingSource source,
    String? customerName,
  }) async {
    await _latency(600);
    if (!_isFree(pitchId, startAt, endAt)) {
      throw const SlotUnavailableException();
    }
    final pitch = _db.pitches.firstWhere((p) => p.id == pitchId);
    final booking = Booking(
      id: _db.nextId('b'),
      pitchId: pitchId,
      userId: userId,
      startAt: startAt,
      endAt: endAt,
      source: source,
      // App bookings wait for the owner; manual ones are confirmed already.
      status: source == BookingSource.app
          ? BookingStatus.pending
          : BookingStatus.confirmed,
      price: SlotService.priceFor(pitch, endAt.difference(startAt).inMinutes),
      customerName: customerName,
    );
    _db.bookings.add(booking);
    return booking;
  }

  @override
  Future<Booking> updateStatus(String bookingId, BookingStatus status) async {
    await _latency(400);
    final occ = _occurrence(bookingId);
    if (occ != null) {
      final booking = _db.recurring[occ.$1].occurrenceOn(occ.$2)!;
      if (status == BookingStatus.cancelled) _skip(occ.$1, occ.$2);
      return booking.copyWith(status: status);
    }
    final i = _db.bookings.indexWhere((b) => b.id == bookingId);
    _db.bookings[i] = _db.bookings[i].copyWith(status: status);
    return _db.bookings[i];
  }

  @override
  Future<void> deleteBooking(String bookingId) async {
    await _latency(300);
    final occ = _occurrence(bookingId);
    if (occ != null) return _skip(occ.$1, occ.$2);
    _db.bookings.removeWhere((b) => b.id == bookingId);
  }

  @override
  Future<RecurringBooking> createRecurringBooking({
    required String pitchId,
    required DateTime startAt,
    required DateTime endAt,
    String? customerName,
  }) async {
    await _latency(600);
    final day = DateTime(startAt.year, startAt.month, startAt.day);
    // Another fixed booking at the same weekly time would clash every week,
    // even if it is skipped this particular week.
    final clashesWithFixed = _db.recurring.any((r) =>
        r.pitchId == pitchId &&
        (r.copyWith(skipped: const {}).occurrenceOn(day)?.overlaps(
                startAt, endAt) ??
            false));
    if (clashesWithFixed || !_isFree(pitchId, startAt, endAt)) {
      throw const SlotUnavailableException();
    }
    final pitch = _db.pitches.firstWhere((p) => p.id == pitchId);
    final minutes = endAt.difference(startAt).inMinutes;
    var rule = RecurringBooking(
      id: _db.nextId('r'),
      pitchId: pitchId,
      dayOfWeek: startAt.weekday % 7,
      startMinutes: startAt.hour * 60 + startAt.minute,
      durationMinutes: minutes,
      startDate: day,
      price: SlotService.priceFor(pitch, minutes),
      customerName: customerName,
    );
    // Weeks that are already booked or blocked keep their booking / block.
    // Only stored bookings / blocks can clash, so scan up to the last one.
    var last = endAt;
    for (final end in [
      for (final b in _db.bookings)
        if (b.pitchId == pitchId) b.endAt,
      for (final b in _db.blocked)
        if (b.pitchId == pitchId) b.endAt,
    ]) {
      if (end.isAfter(last)) last = end;
    }
    final taken = <DateTime>{};
    for (final o in rule.occurrencesBetween(startAt, last)) {
      if (!_isFree(pitchId, o.startAt, o.endAt)) {
        taken.add(DateTime(o.startAt.year, o.startAt.month, o.startAt.day));
      }
    }
    rule = rule.copyWith(skipped: taken);
    _db.recurring.add(rule);
    return rule;
  }

  @override
  Future<RecurringBooking?> getRecurringBooking(String id) async {
    await _latency(100);
    return _db.recurring.where((r) => r.id == id).firstOrNull;
  }

  @override
  Future<void> deleteRecurringBooking(String id) async {
    await _latency(300);
    _db.recurring.removeWhere((r) => r.id == id);
  }

  @override
  Future<List<BlockedSlot>> blockedSlots(String pitchId,
      {required DateTime from, required DateTime to}) async {
    await _latency(100);
    return _db.blocked
        .where((b) => b.pitchId == pitchId && b.overlaps(from, to))
        .toList();
  }

  @override
  Future<BlockedSlot> blockSlot({
    required String pitchId,
    required DateTime startAt,
    required DateTime endAt,
    String? reason,
  }) async {
    await _latency(300);
    if (!_isFree(pitchId, startAt, endAt)) {
      throw const SlotUnavailableException();
    }
    final slot = BlockedSlot(
        id: _db.nextId('x'),
        pitchId: pitchId,
        startAt: startAt,
        endAt: endAt,
        reason: reason);
    _db.blocked.add(slot);
    return slot;
  }

  @override
  Future<void> unblockSlot(String blockedSlotId) async {
    await _latency(300);
    _db.blocked.removeWhere((b) => b.id == blockedSlotId);
  }
}
