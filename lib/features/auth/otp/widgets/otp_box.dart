part of 'otp_widgets_imports.dart';

/// One digit box of the code input.
class OtpBox extends StatelessWidget {
  const OtpBox({
    super.key,
    required this.digit,
    required this.active,
    required this.hasError,
  });

  final String digit;
  final bool active;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          width: 2,
          color: hasError
              ? AppColors.error
              : active
                  ? AppColors.primary
                  : AppColors.border,
        ),
      ),
      child: Text(digit,
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(fontSize: 20)),
    );
  }
}
