part of 'slot_actions_widgets_imports.dart';

/// One week of a fixed weekly booking: cancel this week only, or stop it.
class FixedSlotActions extends StatelessWidget {
  const FixedSlotActions({
    super.key,
    required this.customerName,
    required this.schedule,
    required this.loading,
    required this.onSkipWeek,
    required this.onStop,
  });

  final String customerName;

  /// e.g. «كل الأربعاء • 8:00 م - 9:00 م».
  final String schedule;
  final bool loading;
  final VoidCallback onSkipWeek;
  final VoidCallback onStop;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SlotStateHeader(state: SlotState.manualBooked, text: customerName),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(AppIcons.repeat, size: 18, color: AppColors.slotManual),
            const SizedBox(width: 8),
            Expanded(
              child: Text('${S.fixedBooking}: $schedule',
                  style: t.bodyMedium?.copyWith(
                      color: AppColors.slotManual,
                      fontWeight: FontWeight.w700)),
            ),
          ],
        ),
        const SizedBox(height: 20),
        PrimaryButton(
          label: S.skipThisWeek,
          icon: AppIcons.calendarX,
          loading: loading,
          onPressed: onSkipWeek,
        ),
        const SizedBox(height: 10),
        SecondaryButton(
          label: S.stopFixedBooking,
          icon: AppIcons.delete,
          color: AppColors.error,
          onPressed: loading ? null : onStop,
        ),
      ],
    );
  }
}
