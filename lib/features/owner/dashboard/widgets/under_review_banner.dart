part of 'owner_dashboard_widgets_imports.dart';

/// Shown while the pitch is waiting for admin approval.
class UnderReviewBanner extends StatelessWidget {
  const UnderReviewBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      color: AppColors.warningLight,
      child: Row(
        children: [
          Icon(AppIcons.clock, color: AppColors.pending),
          const SizedBox(width: 10),
          Expanded(
            child: Text(S.underReviewHint,
                style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
