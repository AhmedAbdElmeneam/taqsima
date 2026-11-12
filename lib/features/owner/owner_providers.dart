import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/formatters.dart';
import '../../data/models/models.dart';
import '../../data/providers.dart';
import '../auth/session_controller.dart';

final ownerPitchesProvider = FutureProvider.autoDispose<List<Pitch>>((ref) {
  ref.watch(dataVersionProvider);
  final uid = ref.watch(currentUserIdProvider);
  return ref.watch(pitchRepositoryProvider).pitchesForOwner(uid);
});

/// The pitch the owner is currently managing (null = default).
final selectedPitchIdProvider = StateProvider<String?>((ref) => null);

/// Resolves the managed pitch: the selected one, else the first active one.
final currentOwnerPitchProvider =
    FutureProvider.autoDispose<Pitch?>((ref) async {
  final id = ref.watch(selectedPitchIdProvider);
  final pitches = await ref.watch(ownerPitchesProvider.future);
  if (pitches.isEmpty) return null;
  return pitches.where((p) => p.id == id).firstOrNull ??
      pitches.where((p) => p.status == PitchStatus.active).firstOrNull ??
      pitches.first;
});

/// Upcoming booking requests waiting for the owner's answer.
final ownerRequestsProvider =
    FutureProvider.autoDispose<List<Booking>>((ref) async {
  ref.watch(dataVersionProvider);
  final uid = ref.watch(currentUserIdProvider);
  final list = await ref
      .watch(bookingRepositoryProvider)
      .bookingsForOwner(uid, status: BookingStatus.pending);
  final now = DateTime.now();
  return list.where((b) => b.startAt.isAfter(now)).toList();
});

/// Computed slots for 7 consecutive days starting at [start] (a date).
final weekSlotsProvider = FutureProvider.autoDispose
    .family<List<List<TimeSlot>>, (String, DateTime)>((ref, args) async {
  final (pitchId, start) = args;
  return Future.wait([
    for (var i = 0; i < 7; i++)
      ref.watch(
          daySlotsProvider((pitchId, start.add(Duration(days: i)))).future),
  ]);
});

/// Revenue counted from confirmed / completed bookings only.
int revenueOf(Iterable<TimeSlot> slots) => slots
    .map((s) => s.booking)
    .whereType<Booking>()
    .where((b) =>
        b.status == BookingStatus.confirmed ||
        b.status == BookingStatus.completed)
    .fold(0, (sum, b) => sum + b.price);

DateTime todayDate() => Fmt.dateOnly(DateTime.now());

/// Text typed in the requests search box.
final requestSearchProvider = StateProvider.autoDispose<String>((ref) => '');

/// A pending request plus the text it can be searched by.
class RequestEntry {
  const RequestEntry(this.booking, this.searchText);
  final Booking booking;

  /// Normalized player name + customer name + pitch name.
  final String searchText;
}

/// Requests with their names resolved once (in parallel), independent of
/// what is typed in the search box.
final requestEntriesProvider =
    FutureProvider.autoDispose<List<RequestEntry>>((ref) async {
  final users = ref.watch(userRepositoryProvider);
  final pitches = ref.watch(pitchRepositoryProvider);
  final requests = await ref.watch(ownerRequestsProvider.future);

  return Future.wait(requests.map((b) async {
    final (player, pitch) = await (
      b.userId == null ? Future<AppUser?>.value() : users.getUser(b.userId!),
      pitches.getPitch(b.pitchId),
    ).wait;
    return RequestEntry(
      b,
      Fmt.normalizeArabic(
          '${player?.name ?? ''} ${b.customerName ?? ''} ${pitch?.name ?? ''}'),
    );
  }));
});

/// Pending requests filtered by player or pitch name — no extra I/O per key.
final filteredRequestsProvider =
    Provider.autoDispose<AsyncValue<List<Booking>>>((ref) {
  final query = Fmt.normalizeArabic(ref.watch(requestSearchProvider));
  return ref.watch(requestEntriesProvider).whenData((entries) => [
        for (final e in entries)
          if (query.isEmpty || e.searchText.contains(query)) e.booking,
      ]);
});
