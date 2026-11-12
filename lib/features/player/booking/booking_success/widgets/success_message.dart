part of 'booking_success_widgets_imports.dart';

class SuccessMessage extends StatelessWidget {
  const SuccessMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(S.bookingSent,
            style: t.headlineMedium, textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text(S.bookingSentHint,
            style: t.bodyLarge?.copyWith(color: AppColors.inkMuted),
            textAlign: TextAlign.center),
      ],
    );
  }
}
