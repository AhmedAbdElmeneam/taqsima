part of 'booking_success_imports.dart';

/// Where to go after the booking was sent.
class BookingSuccessController {
  BookingSuccessController(this.bookingId);
  final String bookingId;

  void viewBooking(BuildContext context) =>
      context.go(Routes.playerBooking(bookingId));

  void backHome(BuildContext context) => context.go(Routes.playerHome);
}
