part of 'slot_picker_widgets_imports.dart';

/// Selected slot summary + continue button.
class SlotPickerBottomBar extends StatelessWidget {
  const SlotPickerBottomBar(
      {super.key, required this.selected, required this.onContinue});

  final TimeSlot? selected;
  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final slot = selected;
    return BottomActionBar(
      child: Row(
        children: [
          Expanded(
            child: slot == null
                ? Text(S.selectSlotFirst,
                    style: t.bodyLarge?.copyWith(color: AppColors.inkMuted))
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(Fmt.timeRange(slot.startAt, slot.endAt),
                          style: t.titleMedium),
                      Text(
                          '${Fmt.duration(slot.duration)} • ${S.price(slot.price)}',
                          style: t.bodyMedium?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 150,
            child: PrimaryButton(label: S.continueBtn, onPressed: onContinue),
          ),
        ],
      ),
    );
  }
}
