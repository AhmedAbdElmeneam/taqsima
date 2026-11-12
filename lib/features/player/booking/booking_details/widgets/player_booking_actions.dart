part of 'player_booking_details_widgets_imports.dart';

/// Directions, cancel (with the "too late" hint) and report.
class PlayerBookingActions extends StatelessWidget {
  const PlayerBookingActions({
    super.key,
    required this.showDirections,
    required this.active,
    required this.cancellable,
    required this.onDirections,
    required this.onCancel,
    required this.onReport,
  });

  final bool showDirections;
  final bool active;
  final bool cancellable;
  final VoidCallback onDirections;
  final VoidCallback onCancel;
  final VoidCallback onReport;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showDirections)
          PrimaryButton(
            label: S.directions,
            icon: AppIcons.directions,
            onPressed: onDirections,
          ),
        if (active) ...[
          const SizedBox(height: 10),
          SecondaryButton(
            label: S.cancelBooking,
            icon: AppIcons.close,
            color: AppColors.error,
            onPressed: cancellable ? onCancel : null,
          ),
          if (!cancellable)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(S.cancelNotAllowed,
                  style: t.bodySmall, textAlign: TextAlign.center),
            ),
        ],
        const SizedBox(height: 10),
        TextButton.icon(
          onPressed: onReport,
          icon: Icon(AppIcons.flag, color: AppColors.inkMuted),
          label: Text(S.reportProblem,
              style: t.titleMedium?.copyWith(color: AppColors.inkMuted)),
        ),
      ],
    );
  }
}
