part of 'otp_widgets_imports.dart';

/// Verify button and resend link.
class OtpActions extends StatelessWidget {
  const OtpActions({
    super.key,
    required this.loading,
    required this.onVerify,
    required this.onResend,
  });

  final ValueNotifier<bool> loading;
  final VoidCallback onVerify;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ValueListenableBuilder<bool>(
          valueListenable: loading,
          builder: (context, isLoading, _) => PrimaryButton(
              label: S.verify, loading: isLoading, onPressed: onVerify),
        ),
        const SizedBox(height: 8),
        TextButton(onPressed: onResend, child: const Text(S.resendCode)),
      ],
    );
  }
}
