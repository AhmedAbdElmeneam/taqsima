part of 'slot_actions_widgets_imports.dart';

/// Customer name (manual / fixed booking) or block reason, then save / back.
class SlotTextForm extends StatelessWidget {
  const SlotTextForm({
    super.key,
    required this.mode,
    required this.text,
    required this.loading,
    required this.onSubmit,
    required this.onBack,
  });

  /// [SlotActionMode.manual], [SlotActionMode.fixed] or [SlotActionMode.block].
  final SlotActionMode mode;
  final TextEditingController text;
  final bool loading;
  final VoidCallback onSubmit;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final block = mode == SlotActionMode.block;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          label: block ? S.blockReason : S.customerName,
          hint: block ? S.blockReasonHint : S.customerNameHint,
          controller: text,
          autofocus: true,
          prefixIcon: block ? AppIcons.note : AppIcons.profile,
        ),
        const SizedBox(height: 20),
        PrimaryButton(
          label: switch (mode) {
            SlotActionMode.fixed => S.addFixedBooking,
            SlotActionMode.block => S.blockSlot,
            _ => S.addManualBooking,
          },
          icon: switch (mode) {
            SlotActionMode.fixed => AppIcons.repeat,
            SlotActionMode.block => AppIcons.lock,
            _ => AppIcons.check,
          },
          color: block ? AppColors.ink : null,
          loading: loading,
          onPressed: onSubmit,
        ),
        const SizedBox(height: 8),
        TextButton(onPressed: onBack, child: const Text(S.back)),
      ],
    );
  }
}
