part of 'booking_confirm_imports.dart';

class BookingConfirmScreen extends ConsumerStatefulWidget {
  const BookingConfirmScreen({super.key, required this.slot});
  final TimeSlot slot;

  @override
  ConsumerState<BookingConfirmScreen> createState() =>
      _BookingConfirmScreenState();
}

class _BookingConfirmScreenState extends ConsumerState<BookingConfirmScreen> {
  late final BookingConfirmController controller =
      BookingConfirmController(ref, widget.slot);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slot = widget.slot;
    final pitch = ref.watch(pitchProvider(slot.pitchId)).valueOrNull;

    return Scaffold(
      appBar: AppBar(title: const Text(S.confirmBooking)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (pitch != null) ConfirmPitchBanner(pitch: pitch),
          const SizedBox(height: 16),
          BookingSummaryPanel(slot: slot, pitch: pitch),
          const SizedBox(height: 16),
          const CancellationPolicyPanel(),
          const SizedBox(height: 12),
          const RequestNote(),
        ],
      ),
      bottomNavigationBar: BottomActionBar(
        child: ValueListenableBuilder<bool>(
          valueListenable: controller.loading,
          builder: (context, loading, _) => PrimaryButton(
            label: S.sendBookingRequest,
            icon: AppIcons.check,
            loading: loading,
            onPressed: () => controller.book(context),
          ),
        ),
      ),
    );
  }
}
