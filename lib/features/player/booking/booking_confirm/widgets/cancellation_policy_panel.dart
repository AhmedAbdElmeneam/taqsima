part of 'booking_confirm_widgets_imports.dart';

/// Warning-coloured panel with the cancellation policy.
class CancellationPolicyPanel extends StatelessWidget {
  const CancellationPolicyPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return AppPanel(
      color: AppColors.warningLight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(AppIcons.policy, color: AppColors.pending),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(S.cancellationPolicy,
                    style: t.titleMedium?.copyWith(color: AppColors.pending)),
                const SizedBox(height: 4),
                Text(S.cancellationPolicyText,
                    style: t.bodyMedium?.copyWith(height: 1.6)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
