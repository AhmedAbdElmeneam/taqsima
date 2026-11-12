part of 'slot_actions_widgets_imports.dart';

/// Customer name (manual booking) or block reason, then save / back.
class SlotTextForm extends StatelessWidget {
  const SlotTextForm({
    super.key,
    required this.manual,
    required this.text,
    required this.loading,
    required this.onSubmit,
    required this.onBack,
  });

  final bool manual;
  final TextEditingController text;
  final bool loading;
  final VoidCallback onSubmit;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          label: manual ? S.customerName : S.blockReason,
          hint: manual ? S.customerNameHint : S.blockReasonHint,
          controller: text,
          autofocus: true,
          prefixIcon: manual ? AppIcons.profile : AppIcons.note,
        ),
        const SizedBox(height: 20),
        PrimaryButton(
          label: manual ? S.addManualBooking : S.blockSlot,
          icon: manual ? AppIcons.check : AppIcons.lock,
          color: manual ? null : AppColors.ink,
          loading: loading,
          onPressed: onSubmit,
        ),
        const SizedBox(height: 8),
        TextButton(onPressed: onBack, child: const Text(S.back)),
      ],
    );
  }
}
