part of 'otp_widgets_imports.dart';

/// Tells testers that any 4 digits work in the prototype.
class OtpDemoHint extends StatelessWidget {
  const OtpDemoHint({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      color: AppColors.infoLight,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(AppIcons.info, color: AppColors.info),
          const SizedBox(width: 8),
          Expanded(
            child: Text(S.otpDemoHint,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.info)),
          ),
        ],
      ),
    );
  }
}
