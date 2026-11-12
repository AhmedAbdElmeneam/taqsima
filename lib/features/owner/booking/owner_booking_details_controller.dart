part of 'owner_booking_details_imports.dart';

/// Privacy rule + actions for the owner's booking details.
class OwnerBookingDetailsController {
  OwnerBookingDetailsController(this.ref);
  final WidgetRef ref;

  bool isApp(Booking b) => b.source == BookingSource.app;

  /// The player's phone is shown ONLY once the booking is confirmed.
  bool phoneVisible(Booking b) =>
      isApp(b) &&
      (b.status == BookingStatus.confirmed ||
          b.status == BookingStatus.completed);

  void call(BuildContext context) => showSnack(context, S.callMock);

  Future<void> answer(BuildContext context, Booking b,
          {required bool accept}) =>
      answerBookingRequest(context, ref, b, accept: accept);
}
