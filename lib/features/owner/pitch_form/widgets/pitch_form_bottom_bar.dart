part of 'pitch_form_widgets_imports.dart';

/// Back (from step 2 on) + next / finish.
class PitchFormBottomBar extends StatelessWidget {
  const PitchFormBottomBar({
    super.key,
    required this.showBack,
    required this.isLast,
    required this.saving,
    required this.onBack,
    required this.onNext,
  });

  final bool showBack;
  final bool isLast;
  final bool saving;
  final VoidCallback onBack;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return BottomActionBar(
      child: Row(
        children: [
          if (showBack) ...[
            Expanded(
              flex: 2,
              child: SecondaryButton(label: S.back, onPressed: onBack),
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            flex: 3,
            child: PrimaryButton(
              label: isLast ? S.finish : S.next,
              loading: saving,
              onPressed: onNext,
            ),
          ),
        ],
      ),
    );
  }
}
