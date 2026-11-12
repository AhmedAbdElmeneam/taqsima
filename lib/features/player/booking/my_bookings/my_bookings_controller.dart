part of 'my_bookings_imports.dart';

/// Splits bookings into tabs and handles navigation.
class MyBookingsController {
  /// (upcoming soonest first, past most recent first).
  (List<Booking>, List<Booking>) split(List<Booking> all) {
    final now = DateTime.now();
    final upcoming = all.where((b) => isUpcoming(b, now)).toList();
    final past = all.where((b) => !isUpcoming(b, now)).toList().reversed;
    return (upcoming, past.toList());
  }

  void openBooking(BuildContext context, Booking b) =>
      context.push(Routes.playerBooking(b.id));

  void findPitch(BuildContext context) => context.go(Routes.playerSearch);
}
