part of 'login_widgets_imports.dart';

/// Role icon + "الدخول كلاعب / كصاحب ملعب".
class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key, required this.isOwner});
  final bool isOwner;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(isOwner ? AppIcons.owner : AppIcons.player,
            size: 40, color: AppColors.primary),
        const SizedBox(height: 8),
        Text(isOwner ? S.loginAsOwner : S.loginAsPlayer,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center),
      ],
    );
  }
}
