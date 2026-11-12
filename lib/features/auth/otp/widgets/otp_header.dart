part of 'otp_widgets_imports.dart';

/// Lock icon, title and "sent to <phone>".
class OtpHeader extends StatelessWidget {
  const OtpHeader({super.key, required this.phone});
  final String phone;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(AppIcons.lockOutline, size: 40, color: AppColors.primary),
        const SizedBox(height: 8),
        Text(S.otpTitle, style: t.headlineMedium, textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text(S.otpSentTo(Fmt.phone(phone)),
            style: t.bodyLarge?.copyWith(color: AppColors.inkMuted),
            textAlign: TextAlign.center),
      ],
    );
  }
}
