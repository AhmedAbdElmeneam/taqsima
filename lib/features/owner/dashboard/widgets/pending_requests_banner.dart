part of 'owner_dashboard_widgets_imports.dart';

/// "You have N new requests" → requests tab.
class PendingRequestsBanner extends StatelessWidget {
  const PendingRequestsBanner(
      {super.key, required this.count, required this.onTap});

  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.infoLight,
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Icon(AppIcons.bellRinging, color: AppColors.info, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(S.pendingRequestsBanner(count),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: AppColors.info)),
              ),
              Icon(AppIcons.forward, color: AppColors.info, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
