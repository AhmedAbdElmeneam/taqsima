import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/clock.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/models.dart';
import '../../data/providers.dart';
import '../../data/repositories/repositories.dart';
import '../auth/session_controller.dart';

/// Mock "current location" of the player (Nasr City).
const playerLocation = (lat: 30.06, lng: 31.33);

double distanceKm(double lat1, double lng1, double lat2, double lng2) {
  const r = 6371.0;
  double rad(double d) => d * math.pi / 180;
  final dLat = rad(lat2 - lat1), dLng = rad(lng2 - lng1);
  final a = math.pow(math.sin(dLat / 2), 2) +
      math.cos(rad(lat1)) *
          math.cos(rad(lat2)) *
          math.pow(math.sin(dLng / 2), 2);
  return 2 * r * math.asin(math.sqrt(a));
}

/// Search filters shared by home and search screens.
final searchFilterProvider =
    StateProvider<PitchFilter>((ref) => const PitchFilter());

/// The day the player wants to play (preselected in the slot picker).
final selectedDateProvider =
    StateProvider<DateTime>((ref) => Fmt.dateOnly(DateTime.now()));

final nearbyPitchesProvider =
    FutureProvider.autoDispose<List<Pitch>>((ref) async {
  ref.watch(dataVersionProvider);
  final list = await ref
      .watch(pitchRepositoryProvider)
      .searchPitches(const PitchFilter());
  double d(Pitch p) =>
      distanceKm(playerLocation.lat, playerLocation.lng, p.lat, p.lng);
  return list..sort((a, b) => d(a).compareTo(d(b)));
});

final searchResultsProvider = FutureProvider.autoDispose<List<Pitch>>((ref) {
  ref.watch(dataVersionProvider);
  final filter = ref.watch(searchFilterProvider);
  return ref.watch(pitchRepositoryProvider).searchPitches(filter);
});

final myBookingsProvider = FutureProvider.autoDispose<List<Booking>>((ref) {
  ref.watch(dataVersionProvider);
  final uid = ref.watch(currentUserIdProvider);
  return ref.watch(bookingRepositoryProvider).bookingsForUser(uid);
});

/// Free cancellation window.
const cancellationWindow = Duration(hours: 6);

bool canCancel(Booking b, [DateTime? now]) =>
    (b.status == BookingStatus.pending ||
        b.status == BookingStatus.confirmed) &&
    b.startAt.difference(now ?? DateTime.now()) >= cancellationWindow;

bool isUpcoming(Booking b, [DateTime? now]) =>
    b.endAt.isAfter(now ?? DateTime.now()) &&
    (b.status == BookingStatus.pending || b.status == BookingStatus.confirmed);

/// The player's next match (pending or confirmed), if any.
final nextMatchProvider = FutureProvider.autoDispose<Booking?>((ref) async {
  // Re-evaluated on every clock tick so a finished match drops off.
  final now = ref.watch(clockProvider).valueOrNull ?? DateTime.now();
  final all = await ref.watch(myBookingsProvider.future);
  final upcoming = all.where((b) => isUpcoming(b, now)).toList()
    ..sort((a, b) => a.startAt.compareTo(b.startAt));
  return upcoming.firstOrNull;
});

/// Earliest free slot left today at each of the nearest pitches.
/// All dependencies are watched synchronously; slot loads run in parallel.
final availableTodayProvider =
    FutureProvider.autoDispose<List<(Pitch, TimeSlot)>>((ref) async {
  final pitches = ref.watch(nearbyPitchesProvider).valueOrNull;
  if (pitches == null) return const [];
  final today = Fmt.dateOnly(DateTime.now());
  final nearest = pitches.take(6).toList();
  final daySlots = await Future.wait([
    for (final p in nearest) ref.watch(daySlotsProvider((p.id, today)).future),
  ]);

  final result = <(Pitch, TimeSlot)>[];
  for (final (i, slots) in daySlots.indexed) {
    final free = slots.where((s) => s.isBookable).firstOrNull;
    if (free != null) result.add((nearest[i], free));
  }
  result.sort((a, b) => a.$2.startAt.compareTo(b.$2.startAt));
  return result;
});

/// Pitches the player has played at before (most recent first).
final bookAgainProvider = FutureProvider.autoDispose<List<Pitch>>((ref) async {
  final repo = ref.watch(pitchRepositoryProvider);
  final all = await ref.watch(myBookingsProvider.future);

  final ids = <String>{};
  for (final b in all.reversed) {
    if (b.status == BookingStatus.completed) ids.add(b.pitchId);
  }
  final pitches = await Future.wait(ids.take(4).map(repo.getPitch));
  return pitches.whereType<Pitch>().toList();
});
