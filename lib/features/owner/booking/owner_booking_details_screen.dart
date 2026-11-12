part of 'owner_booking_details_imports.dart';

/// Owner view of a booking. The player's phone is shown ONLY once confirmed.
class OwnerBookingDetailsScreen extends ConsumerWidget {
  const OwnerBookingDetailsScreen({super.key, required this.bookingId});
  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = OwnerBookingDetailsController(ref);
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
          final isApp = controller.isApp(b);
          final player =
              isApp ? ref.watch(userProvider(b.userId!)).valueOrNull : null;
          final pitch = ref.watch(pitchProvider(b.pitchId)).valueOrNull;
          final phoneVisible = controller.phoneVisible(b);

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              BookingStatusBanner(status: b.status),
              const SizedBox(height: 16),
              BookingCustomerPanel(
                booking: b,
                player: player,
                phoneVisible: phoneVisible,
              ),
              const SizedBox(height: 12),
              BookingTimePanel(booking: b, pitch: pitch),
              const SizedBox(height: 20),
              OwnerBookingActions(
                canCall: phoneVisible,
                pending: b.status == BookingStatus.pending,
                onCall: () => controller.call(context),
                onAnswer: (accept) =>
                    controller.answer(context, b, accept: accept),
              ),
            ],
          );
        },
      ),
    );
  }
}
