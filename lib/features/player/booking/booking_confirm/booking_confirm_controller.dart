part of 'booking_confirm_imports.dart';

/// Sends the booking request for one slot.
class BookingConfirmController {
  BookingConfirmController(this.ref, this.slot);

  final WidgetRef ref;
  final TimeSlot slot;
  final loading = ValueNotifier(false);

  bool _disposed = false;

  Future<void> book(BuildContext context) async {
    loading.value = true;
    try {
      final booking = await ref.read(bookingRepositoryProvider).createBooking(
            pitchId: slot.pitchId,
            userId: ref.read(currentUserIdProvider),
            startAt: slot.startAt,
            endAt: slot.endAt,
            source: BookingSource.app,
          );
      ref.refreshData();
      if (context.mounted) context.go(Routes.bookingSuccess(booking.id));
    } on SlotUnavailableException {
      ref.refreshData();
      if (!context.mounted) return;
      showSnack(context, S.slotJustTaken);
      context.pop();
    } finally {
      if (!_disposed) loading.value = false;
    }
  }

  void dispose() {
    _disposed = true;
    loading.dispose();
  }
}
