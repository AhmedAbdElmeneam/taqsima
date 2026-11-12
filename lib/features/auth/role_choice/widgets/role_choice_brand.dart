part of 'role_choice_widgets_imports.dart';

/// Logo, app name and tagline; slides up when [raised].
class RoleChoiceBrand extends StatelessWidget {
  const RoleChoiceBrand({super.key, required this.raised});
  final bool raised;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return AnimatedAlign(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      alignment: raised ? const Alignment(0, .2) : Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
            ),
            // The ball rolls in once when the app opens.
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeOutBack,
              builder: (_, v, child) => Transform.rotate(
                angle: (1 - v) * -6.283,
                child: Transform.scale(scale: .4 + .6 * v, child: child),
              ),
              child: Icon(AppIcons.ball, size: 60, color: AppColors.primary),
            ),
          ),
          const SizedBox(height: 16),
          Text(S.appName,
              style: t.headlineMedium
                  ?.copyWith(color: Colors.white, fontSize: 28)),
          Text(S.appTagline,
              style: t.bodyLarge?.copyWith(color: Colors.white70)),
        ],
      ),
    );
  }
}
