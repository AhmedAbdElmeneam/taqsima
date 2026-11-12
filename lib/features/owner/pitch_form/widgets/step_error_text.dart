part of 'pitch_form_widgets_imports.dart';

/// Red message under the step (e.g. "choose an area").
class StepErrorText extends StatelessWidget {
  const StepErrorText(this.message, {super.key});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Text(message,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppColors.error)),
    );
  }
}
