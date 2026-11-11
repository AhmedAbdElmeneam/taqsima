import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

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
