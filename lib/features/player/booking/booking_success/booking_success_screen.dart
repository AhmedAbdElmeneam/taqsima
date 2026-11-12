part of 'booking_success_imports.dart';

class BookingSuccessScreen extends ConsumerWidget {
  const BookingSuccessScreen({super.key, required this.bookingId});
  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = BookingSuccessController(bookingId);
    final booking = ref.watch(bookingProvider(bookingId)).valueOrNull;
    final pitch = booking == null
        ? null
        : ref.watch(pitchProvider(booking.pitchId)).valueOrNull;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) controller.backHome(context);
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),
                const SuccessCheck(),
                const SizedBox(height: 24),
                const SuccessMessage(),
                const SizedBox(height: 24),
                if (booking != null && pitch != null)
                  SuccessBookingPanel(booking: booking, pitch: pitch),
                const Spacer(),
                PrimaryButton(
                  label: S.viewBooking,
                  onPressed: () => controller.viewBooking(context),
                ),
                const SizedBox(height: 10),
                SecondaryButton(
                  label: S.backToHome,
                  onPressed: () => controller.backHome(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
