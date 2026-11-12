part of 'booking_requests_imports.dart';

/// Search + accept / reject for pending booking requests.
class BookingRequestsController {
  BookingRequestsController(this.ref);

  final WidgetRef ref;
  final search = TextEditingController();

  void onSearchChanged(String v) =>
      ref.read(requestSearchProvider.notifier).state = v;

  void clearSearch() {
    search.clear();
    ref.read(requestSearchProvider.notifier).state = '';
  }

  void openBooking(BuildContext context, Booking b) =>
      context.push(Routes.ownerBooking(b.id));

  Future<void> answer(BuildContext context, Booking b,
          {required bool accept}) =>
      answerBookingRequest(context, ref, b, accept: accept);

  void dispose() => search.dispose();
}
