part of 'otp_imports.dart';

/// State and actions for the verification-code screen.
class OtpController {
  OtpController(this.ref, this.args);

  final WidgetRef ref;
  final OtpArgs args;

  static const codeLength = 4;

  final code = TextEditingController();
  final focus = FocusNode();
  final loading = ValueNotifier(false);

  /// Message under the boxes (null = no error).
  final error = ValueNotifier<String?>(null);

  bool _disposed = false;

  void clearError() => error.value = null;

  /// Verifies the code. On success the router redirects to the right home.
  Future<void> verify() async {
    if (code.text.length != codeLength) {
      error.value = S.otpIncomplete;
      return;
    }
    loading.value = true;
    error.value = null;
    try {
      await ref.read(sessionProvider.notifier).verifyOtp(
            phone: args.phone,
            code: code.text,
            role: args.role,
            name: args.name,
          );
    } catch (_) {
      if (!_disposed) error.value = S.somethingWrong;
    } finally {
      if (!_disposed) loading.value = false;
    }
  }

  /// Mock: just confirms. With a backend, request a new code here.
  void resend(BuildContext context) => showSnack(context, S.codeResent);

  void dispose() {
    _disposed = true;
    code.dispose();
    focus.dispose();
    loading.dispose();
    error.dispose();
  }
}
