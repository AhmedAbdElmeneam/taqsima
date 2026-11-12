part of 'player_booking_details_imports.dart';

/// Player view of a booking. The owner's phone number is never shown here.
class PlayerBookingDetailsScreen extends ConsumerWidget {
  const PlayerBookingDetailsScreen({super.key, required this.bookingId});
  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = PlayerBookingDetailsController(ref, bookingId);
    final booking = ref.watch(bookingProvider(bookingId));

    return Scaffold(
      appBar: AppBar(title: const Text(S.bookingDetails)),
      body: AsyncView(
        value: booking,
        builder: (b) {
          if (b == null) {
            return const EmptyState(
                icon: AppIcons.notFound, title: S.bookingNotFound);
          }
          final pitch = ref.watch(pitchProvider(b.pitchId)).valueOrNull;

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              BookingStatusBanner(
                status: b.status,
                message:
                    b.status == BookingStatus.pending ? S.requestNote : null,
              ),
              const SizedBox(height: 16),
              if (pitch != null)
                BookingPitchCard(
                  pitch: pitch,
                  onTap: () => controller.openPitch(context, pitch),
                ),
              const SizedBox(height: 16),
              BookingInfoPanel(booking: b),
              const SizedBox(height: 20),
              PlayerBookingActions(
                showDirections: pitch != null,
                active: controller.isActive(b),
                cancellable: controller.isCancellable(b),
                onDirections: () => controller.directions(context),
                onCancel: () => controller.cancel(context),
                onReport: () => controller.report(context),
              ),
            ],
          );
        },
      ),
    );
  }
}
