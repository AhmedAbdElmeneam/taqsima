import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'mock/mock_db.dart';
import 'mock/mock_repositories.dart';
import 'models/models.dart';
import 'repositories/repositories.dart';
import 'services/slot_service.dart';

// ---------------------------------------------------------------------------
// Wiring. To plug in a real backend, replace the Mock* implementations here.
// ---------------------------------------------------------------------------

final mockDbProvider = Provider<MockDb>((ref) => MockDb());

final authRepositoryProvider = Provider<AuthRepository>(
    (ref) => MockAuthRepository(ref.watch(mockDbProvider)));
final userRepositoryProvider = Provider<UserRepository>(
    (ref) => MockUserRepository(ref.watch(mockDbProvider)));
final pitchRepositoryProvider = Provider<PitchRepository>(
    (ref) => MockPitchRepository(ref.watch(mockDbProvider)));
final bookingRepositoryProvider = Provider<BookingRepository>(
    (ref) => MockBookingRepository(ref.watch(mockDbProvider)));
final slotServiceProvider = Provider<SlotService>((ref) => const SlotService());

/// Bumped after every mutation so all queries re-fetch. With a real backend
/// this can be replaced by streams / realtime listeners.
final dataVersionProvider = StateProvider<int>((ref) => 0);

extension DataRefresh on WidgetRef {
  void refreshData() => read(dataVersionProvider.notifier).state++;
}

// ---------------------------------------------------------------------------
// Shared queries (used by both player and owner features).
// ---------------------------------------------------------------------------

final pitchProvider =
    FutureProvider.autoDispose.family<Pitch?, String>((ref, id) {
  ref.watch(dataVersionProvider);
  return ref.watch(pitchRepositoryProvider).getPitch(id);
});

final workingHoursProvider =
    FutureProvider.autoDispose.family<List<WorkingHours>, String>((ref, id) {
  ref.watch(dataVersionProvider);
  return ref.watch(pitchRepositoryProvider).workingHours(id);
});

final bookingProvider =
    FutureProvider.autoDispose.family<Booking?, String>((ref, id) {
  ref.watch(dataVersionProvider);
  return ref.watch(bookingRepositoryProvider).getBooking(id);
});

final userProvider =
    FutureProvider.autoDispose.family<AppUser?, String>((ref, id) {
  ref.watch(dataVersionProvider);
  return ref.watch(userRepositoryProvider).getUser(id);
});

final areasProvider = FutureProvider<List<String>>(
    (ref) => ref.watch(pitchRepositoryProvider).areas());

/// Computed slots for one pitch on one day. [day] must be a date (00:00).
final daySlotsProvider = FutureProvider.autoDispose
    .family<List<TimeSlot>, (String, DateTime)>((ref, args) async {
  ref.watch(dataVersionProvider);
  final (pitchId, day) = args;
  final pitchRepo = ref.watch(pitchRepositoryProvider);
  final bookingRepo = ref.watch(bookingRepositoryProvider);

  final pitch = await pitchRepo.getPitch(pitchId);
  if (pitch == null) return const [];
  final to = day.add(const Duration(days: 2));
  final results = await Future.wait([
    pitchRepo.workingHours(pitchId),
    bookingRepo.bookingsForPitch(pitchId, from: day, to: to),
    bookingRepo.blockedSlots(pitchId, from: day, to: to),
  ]);
  return ref.watch(slotServiceProvider).slotsForDay(
        pitch: pitch,
        workingHours: results[0] as List<WorkingHours>,
        day: day,
        bookings: results[1] as List<Booking>,
        blocked: results[2] as List<BlockedSlot>,
      );
});
