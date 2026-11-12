part of 'working_hours_widgets_imports.dart';

/// Hint + 60 / 90 minute toggle.
class SlotDurationPicker extends StatelessWidget {
  const SlotDurationPicker({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  final List<int> options;
  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(S.workingHoursHint,
            style: t.bodyMedium?.copyWith(color: AppColors.inkMuted)),
        const SizedBox(height: 14),
        Text(S.slotDurationLabel, style: t.titleMedium),
        const SizedBox(height: 8),
        SegmentedButton<int>(
          showSelectedIcon: false,
          style: SegmentedButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            selectedBackgroundColor: AppColors.primaryLight,
            selectedForegroundColor: AppColors.primaryDark,
          ),
          segments: [
            for (final d in options)
              ButtonSegment(value: d, label: Text(S.slotDuration(d))),
          ],
          selected: {selected},
          onSelectionChanged: (s) => onChanged(s.first),
        ),
      ],
    );
  }
}
