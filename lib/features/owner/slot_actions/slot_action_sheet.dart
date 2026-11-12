part of 'slot_actions_imports.dart';

/// Bottom-sheet content for one slot; opened by [onOwnerSlotTap].
class SlotActionSheet extends ConsumerStatefulWidget {
  const SlotActionSheet({super.key, required this.slot});
  final TimeSlot slot;

  @override
  ConsumerState<SlotActionSheet> createState() => _SlotActionSheetState();
}

class _SlotActionSheetState extends ConsumerState<SlotActionSheet> {
  late final SlotActionsController controller =
      SlotActionsController(ref, widget.slot);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.slot;
    return ListenableBuilder(
      listenable: Listenable.merge([controller.mode, controller.loading]),
      builder: (context, _) {
        final loading = controller.loading.value;
        switch (s.state) {
          case SlotState.blocked:
            return BlockedSlotActions(
              reason: s.blockedSlot?.reason ?? S.blocked,
              loading: loading,
              onUnblock: () => controller.unblock(context),
            );
          case SlotState.manualBooked:
            return ManualSlotActions(
              customerName: s.booking!.customerName ?? S.noName,
              loading: loading,
              onView: () => controller.viewDetails(context),
              onRemove: () => controller.removeManual(context),
            );
          case SlotState.appBooked:
            return const SizedBox.shrink();
          case SlotState.available:
            final mode = controller.mode.value;
            if (mode == SlotActionMode.choose) {
              return FreeSlotOptions(onChoose: controller.setMode);
            }
            return SlotTextForm(
              manual: mode == SlotActionMode.manual,
              text: controller.text,
              loading: loading,
              onSubmit: () => controller.submit(context),
              onBack: () => controller.setMode(SlotActionMode.choose),
            );
        }
      },
    );
  }
}
