part of 'login_widgets_imports.dart';

/// "إرسال رمز التحقق" with a spinner while the request is running.
class LoginSubmitButton extends StatelessWidget {
  const LoginSubmitButton(
      {super.key, required this.loading, required this.onPressed});

  final ValueNotifier<bool> loading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: loading,
      builder: (context, isLoading, _) => PrimaryButton(
        label: S.sendCode,
        icon: AppIcons.sms,
        loading: isLoading,
        onPressed: onPressed,
      ),
    );
  }
}
