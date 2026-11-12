part of 'booking_success_widgets_imports.dart';

/// Check pops in with a short celebratory burst behind it.
class SuccessCheck extends StatelessWidget {
  const SuccessCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const ConfettiBurst(size: 240),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 600),
          curve: Curves.elasticOut,
          builder: (_, v, child) => Transform.scale(scale: v, child: child),
          child: Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(AppIcons.check, size: 52, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
