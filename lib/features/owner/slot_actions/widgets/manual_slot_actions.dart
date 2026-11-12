part of 'slot_actions_widgets_imports.dart';

/// Manual booking: customer name, view details, remove.
class ManualSlotActions extends StatelessWidget {
  const ManualSlotActions({
    super.key,
    required this.customerName,
    required this.loading,
    required this.onView,
    required this.onRemove,
  });

  final String customerName;
  final bool loading;
  final VoidCallback onView;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SlotStateHeader(state: SlotState.manualBooked, text: customerName),
        const SizedBox(height: 20),
        PrimaryButton(label: S.viewDetails, onPressed: onView),
        const SizedBox(height: 10),
        SecondaryButton(
          label: S.removeManualBooking,
          icon: AppIcons.delete,
          color: AppColors.error,
          onPressed: loading ? null : onRemove,
        ),
      ],
    );
  }
}
