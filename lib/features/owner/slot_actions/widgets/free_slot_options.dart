part of 'slot_actions_widgets_imports.dart';

/// Free slot: choose manual booking, fixed weekly booking or block.
class FreeSlotOptions extends StatelessWidget {
  const FreeSlotOptions(
      {super.key, required this.dayOfWeek, required this.onChoose});

  /// Weekday of the tapped slot (0 = Sunday), for the fixed-booking hint.
  final int dayOfWeek;
  final ValueChanged<SlotActionMode> onChoose;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(S.slotActions,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center),
        const SizedBox(height: 14),
        SlotOptionTile(
          icon: AppIcons.manual,
          color: AppColors.slotManual,
          background: AppColors.slotManualBg,
          title: S.addManualBooking,
          subtitle: S.addManualBookingHint,
          onTap: () => onChoose(SlotActionMode.manual),
        ),
        const SizedBox(height: 10),
        SlotOptionTile(
          icon: AppIcons.repeat,
          color: AppColors.slotManual,
          background: AppColors.slotManualBg,
          title: S.addFixedBooking,
          subtitle: S.fixedBookingHint(dayOfWeek),
          onTap: () => onChoose(SlotActionMode.fixed),
        ),
        const SizedBox(height: 10),
        SlotOptionTile(
          icon: AppIcons.lock,
          color: AppColors.slotBlocked,
          background: AppColors.slotBlockedBg,
          title: S.blockSlot,
          subtitle: S.blockSlotHint,
          onTap: () => onChoose(SlotActionMode.block),
        ),
      ],
    );
  }
}
