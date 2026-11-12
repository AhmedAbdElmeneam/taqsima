part of 'otp_imports.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key, required this.args});
  final OtpArgs args;

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  late final OtpController controller = OtpController(ref, widget.args);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            OtpHeader(phone: widget.args.phone),
            const SizedBox(height: 28),
            OtpCodeInput(
              controller: controller.code,
              focusNode: controller.focus,
              length: OtpController.codeLength,
              error: controller.error,
              onChanged: controller.clearError,
              onCompleted: controller.verify,
            ),
            const SizedBox(height: 12),
            const OtpDemoHint(),
            const SizedBox(height: 24),
            OtpActions(
              loading: controller.loading,
              onVerify: controller.verify,
              onResend: () => controller.resend(context),
            ),
          ],
        ),
      ),
    );
  }
}
