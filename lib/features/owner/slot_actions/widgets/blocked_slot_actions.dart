part of 'slot_actions_widgets_imports.dart';

/// Blocked slot: reason + unblock.
class BlockedSlotActions extends StatelessWidget {
  const BlockedSlotActions({
    super.key,
    required this.reason,
    required this.loading,
    required this.onUnblock,
  });

  final String reason;
  final bool loading;
  final VoidCallback onUnblock;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SlotStateHeader(state: SlotState.blocked, text: reason),
        const SizedBox(height: 20),
        PrimaryButton(
          label: S.unblock,
          icon: AppIcons.unlock,
          loading: loading,
          onPressed: onUnblock,
        ),
      ],
    );
  }
}
