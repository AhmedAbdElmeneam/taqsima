part of 'slot_actions_imports.dart';

/// Owner taps any slot (dashboard or calendar):
/// - free → block it or record a manual booking (optional customer name)
/// - blocked → unblock
/// - manual booking → view / remove
/// - app booking → open booking details
Future<void> onOwnerSlotTap(BuildContext context, TimeSlot slot) async {
  final booking = slot.booking;
  // App bookings and finished bookings: just show the details.
  if (booking != null &&
      (slot.state == SlotState.appBooked || slot.isPast)) {
    context.push(Routes.ownerBooking(booking.id));
    return;
  }
  if (slot.isPast) return;
  await showAppBottomSheet<void>(
    context,
    title:
        '${Fmt.dayRelative(slot.startAt)} • ${Fmt.timeRange(slot.startAt, slot.endAt)}',
    builder: (_) => SlotActionSheet(slot: slot),
  );
}

/// State and repository calls behind the slot action sheet.
class SlotActionsController {
  SlotActionsController(this.ref, this.slot);

  final WidgetRef ref;
  final TimeSlot slot;

  final text = TextEditingController();
  final mode = ValueNotifier(SlotActionMode.choose);
  final loading = ValueNotifier(false);

  bool _disposed = false;

  /// Typed name / reason, or null when left empty.
  String? get _value => text.text.trim().isEmpty ? null : text.text.trim();

  void setMode(SlotActionMode m) => mode.value = m;

  /// Runs [action], refreshes data, closes the sheet and reports the result.
  Future<void> _run(BuildContext context,
      Future<void> Function(BookingRepository repo) action, String done) async {
    loading.value = true;
    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);
    try {
      await action(ref.read(bookingRepositoryProvider));
      ref.refreshData();
      nav.pop();
      messenger.showSnackBar(SnackBar(content: Text(done)));
    } on SlotUnavailableException {
      ref.refreshData();
      nav.pop();
      messenger.showSnackBar(const SnackBar(content: Text(S.slotJustTaken)));
    } finally {
      if (!_disposed) loading.value = false;
    }
  }

  Future<void> unblock(BuildContext context) => _run(
      context, (r) => r.unblockSlot(slot.blockedSlot!.id), S.slotUnblocked);

  Future<void> removeManual(BuildContext context) => _run(context,
      (r) => r.deleteBooking(slot.booking!.id), S.manualBookingRemoved);

  void viewDetails(BuildContext context) {
    Navigator.pop(context);
    context.push(Routes.ownerBooking(slot.booking!.id));
  }

  /// Saves the manual booking or the block, depending on [mode].
  Future<void> submit(BuildContext context) => mode.value ==
          SlotActionMode.manual
      ? _run(
          context,
          (r) => r.createBooking(
                pitchId: slot.pitchId,
                userId: null,
                startAt: slot.startAt,
                endAt: slot.endAt,
                source: BookingSource.manual,
                customerName: _value,
              ),
          S.manualBookingAdded)
      : _run(
          context,
          (r) => r.blockSlot(
                pitchId: slot.pitchId,
                startAt: slot.startAt,
                endAt: slot.endAt,
                reason: _value,
              ),
          S.slotBlocked);

  void dispose() {
    _disposed = true;
    text.dispose();
    mode.dispose();
    loading.dispose();
  }
}
