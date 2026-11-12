part of 'player_booking_details_imports.dart';

/// Cancel / report / directions for one of the player's bookings.
class PlayerBookingDetailsController {
  PlayerBookingDetailsController(this.ref, this.bookingId);

  final WidgetRef ref;
  final String bookingId;

  bool isActive(Booking b) =>
      b.status == BookingStatus.pending || b.status == BookingStatus.confirmed;

  bool isCancellable(Booking b) => canCancel(b);

  Future<void> cancel(BuildContext context) async {
    final ok = await showConfirmSheet(
      context,
      title: S.cancelBookingQ,
      message: S.cancellationPolicyText,
      confirmLabel: S.yesCancel,
      cancelLabel: S.noKeep,
      destructive: true,
    );
    if (!ok) return;
    await ref
        .read(bookingRepositoryProvider)
        .updateStatus(bookingId, BookingStatus.cancelled);
    ref.refreshData();
    if (context.mounted) showSnack(context, S.bookingCancelled);
  }

  Future<void> report(BuildContext context) async {
    final sent = await showAppBottomSheet<bool>(
      context,
      title: S.reportProblem,
      builder: (_) => const ReportProblemSheet(),
    );
    if (sent == true && context.mounted) showSnack(context, S.reportSent);
  }

  void directions(BuildContext context) =>
      showSnack(context, S.directionsMock);

  void openPitch(BuildContext context, Pitch pitch) =>
      context.push(Routes.pitch(pitch.id));
}
