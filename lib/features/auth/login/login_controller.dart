part of 'login_imports.dart';

/// State and actions for the phone login / sign-up screen.
/// API work (requesting the OTP) lives here, not in the widgets.
class LoginController {
  LoginController(this.ref, this.role);

  final WidgetRef ref;
  final UserRole role;

  final formKey = GlobalKey<FormState>();
  final phone = TextEditingController();
  final name = TextEditingController();

  /// false = log in, true = create account.
  final isSignup = ValueNotifier(false);
  final loading = ValueNotifier(false);

  static final _egyptianMobile = RegExp(r'^01[0125]\d{8}$');

  bool get isOwner => role == UserRole.owner;

  String? validatePhone(String? value) =>
      _egyptianMobile.hasMatch(value ?? '') ? null : S.invalidPhone;

  String? validateName(String? value) =>
      isSignup.value && (value ?? '').trim().isEmpty ? S.nameRequired : null;

  /// Validates, asks the backend to send an OTP, then opens the OTP screen.
  Future<void> submit(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;
    loading.value = true;
    try {
      await ref.read(sessionProvider.notifier).requestOtp(phone.text);
      if (!context.mounted) return;
      context.push(
        Routes.otp,
        extra: OtpArgs(
          phone: phone.text,
          role: role,
          name: isSignup.value ? name.text : null,
        ),
      );
    } finally {
      // The user may have left the screen while the request was running.
      if (!_disposed) loading.value = false;
    }
  }

  bool _disposed = false;

  void dispose() {
    _disposed = true;
    phone.dispose();
    name.dispose();
    isSignup.dispose();
    loading.dispose();
  }
}
