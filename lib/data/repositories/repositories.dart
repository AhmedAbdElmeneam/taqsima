import '../models/models.dart';

/// Repository contracts. The UI only depends on these interfaces; the mock
/// implementations live in `data/mock`. A real backend (REST / Firebase /
/// Supabase) plugs in by implementing them and swapping the providers in
/// `data/providers.dart`.

class PitchFilter {
  const PitchFilter({this.query, this.area, this.type, this.maxPrice});

  final String? query;
  final String? area;
  final PitchType? type;
  final int? maxPrice;

  bool get isEmpty =>
      (query == null || query!.isEmpty) &&
      area == null &&
      type == null &&
      maxPrice == null;

  PitchFilter copyWith({
    String? Function()? query,
    String? Function()? area,
    PitchType? Function()? type,
    int? Function()? maxPrice,
  }) =>
      PitchFilter(
        query: query != null ? query() : this.query,
        area: area != null ? area() : this.area,
        type: type != null ? type() : this.type,
        maxPrice: maxPrice != null ? maxPrice() : this.maxPrice,
      );
}

class SlotUnavailableException implements Exception {
  const SlotUnavailableException();
}

abstract interface class AuthRepository {
  Future<void> requestOtp(String phone);

  /// Throws if the code is wrong.
  Future<AppUser> verifyOtp({
    required String phone,
    required String code,
    required UserRole role,
    String? name,
  });

  Future<void> signOut();
}

abstract interface class UserRepository {
  Future<AppUser?> getUser(String id);
  Future<AppUser> updateName(String id, String name);
}

abstract interface class PitchRepository {
  /// Active pitches visible to players.
  Future<List<Pitch>> searchPitches(PitchFilter filter);
  Future<List<String>> areas();
  Future<Pitch?> getPitch(String id);
  Future<List<Pitch>> pitchesForOwner(String ownerId);

  /// Creates (id empty) or updates a pitch. New pitches start as pending.
  Future<Pitch> savePitch(Pitch pitch);

  Future<List<WorkingHours>> workingHours(String pitchId);
  Future<void> saveWorkingHours(String pitchId, List<WorkingHours> hours);
}

abstract interface class BookingRepository {
  Future<List<Booking>> bookingsForPitch(String pitchId,
      {required DateTime from, required DateTime to});
  Future<List<Booking>> bookingsForUser(String userId);
  Future<List<Booking>> bookingsForOwner(String ownerId,
      {BookingStatus? status});
  Future<Booking?> getBooking(String id);

  /// Throws [SlotUnavailableException] if the time is no longer free.
  Future<Booking> createBooking({
    required String pitchId,
    required String? userId,
    required DateTime startAt,
    required DateTime endAt,
    required BookingSource source,
    String? customerName,
  });

  /// For one week of a fixed booking, cancelling skips that week only.
  Future<Booking> updateStatus(String bookingId, BookingStatus status);

  /// For one week of a fixed booking, skips that week only.
  Future<void> deleteBooking(String bookingId);

  /// Fixed weekly booking starting at [startAt] and repeating every week on
  /// the same weekday and time. Weeks already taken (booked / blocked) are
  /// skipped. Throws [SlotUnavailableException] if [startAt] itself is taken.
  Future<RecurringBooking> createRecurringBooking({
    required String pitchId,
    required DateTime startAt,
    required DateTime endAt,
    String? customerName,
  });

  Future<RecurringBooking?> getRecurringBooking(String id);

  /// Stops the fixed booking for every coming week.
  Future<void> deleteRecurringBooking(String id);

  Future<List<BlockedSlot>> blockedSlots(String pitchId,
      {required DateTime from, required DateTime to});
  Future<BlockedSlot> blockSlot({
    required String pitchId,
    required DateTime startAt,
    required DateTime endAt,
    String? reason,
  });
  Future<void> unblockSlot(String blockedSlotId);
}
