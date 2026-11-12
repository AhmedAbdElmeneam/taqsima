part of 'pitch_form_widgets_imports.dart';

/// Progress bars with step names + "step x of n".
class StepIndicator extends StatelessWidget {
  const StepIndicator({super.key, required this.steps, required this.current});

  final List<String> steps;
  final int current;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
          child: Row(
            children: [
              for (var i = 0; i < steps.length; i++) ...[
                Expanded(
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        height: 6,
                        decoration: BoxDecoration(
                          color: i <= current
                              ? AppColors.primary
                              : AppColors.border,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(steps[i],
                          style: t.bodySmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: i == current
                                ? AppColors.primary
                                : AppColors.inkMuted,
                          )),
                    ],
                  ),
                ),
                if (i < steps.length - 1) const SizedBox(width: 6),
              ],
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(S.stepOf(current + 1, steps.length), style: t.bodySmall),
        ),
      ],
    );
  }
}
