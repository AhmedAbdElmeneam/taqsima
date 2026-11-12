part of 'login_widgets_imports.dart';

/// تسجيل الدخول / حساب جديد toggle.
class LoginModeSwitch extends StatelessWidget {
  const LoginModeSwitch({super.key, required this.isSignup});
  final ValueNotifier<bool> isSignup;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isSignup,
      builder: (context, signup, _) => SegmentedButton<bool>(
        segments: const [
          ButtonSegment(value: false, label: Text(S.login)),
          ButtonSegment(value: true, label: Text(S.signup)),
        ],
        selected: {signup},
        showSelectedIcon: false,
        style: SegmentedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          selectedBackgroundColor: AppColors.primaryLight,
          selectedForegroundColor: AppColors.primaryDark,
          textStyle: Theme.of(context).textTheme.titleMedium,
        ),
        onSelectionChanged: (s) => isSignup.value = s.first,
      ),
    );
  }
}
