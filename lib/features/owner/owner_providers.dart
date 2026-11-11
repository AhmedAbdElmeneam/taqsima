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
  final pitches = await ref.watch(ownerPitchesProvider.future);
  if (pitches.isEmpty) return null;
  final id = ref.watch(selectedPitchIdProvider);
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

/// Pending requests filtered by player name or pitch name.
final filteredRequestsProvider =
    FutureProvider.autoDispose<List<Booking>>((ref) async {
  final requests = await ref.watch(ownerRequestsProvider.future);
  final query = Fmt.normalizeArabic(ref.watch(requestSearchProvider));
  if (query.isEmpty) return requests;

  final users = ref.watch(userRepositoryProvider);
  final pitches = ref.watch(pitchRepositoryProvider);
  final result = <Booking>[];
  for (final b in requests) {
    final player = b.userId == null ? null : await users.getUser(b.userId!);
    final pitch = await pitches.getPitch(b.pitchId);
    final haystack = Fmt.normalizeArabic(
        '${player?.name ?? ''} ${b.customerName ?? ''} ${pitch?.name ?? ''}');
    if (haystack.contains(query)) result.add(b);
  }
  return result;
});
