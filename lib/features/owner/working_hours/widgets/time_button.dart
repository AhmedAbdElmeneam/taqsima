part of 'working_hours_widgets_imports.dart';

/// Label + time (+ "next day") that opens the time list.
class TimeButton extends StatelessWidget {
  const TimeButton({
    super.key,
    required this.label,
    required this.minutes,
    required this.onTap,
    this.nextDay = false,
  });

  final String label;
  final int minutes;
  final VoidCallback onTap;
  final bool nextDay;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Material(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(AppSpacing.radius),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radius),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: t.bodySmall),
                    Text(Fmt.minutesOfDay(minutes), style: t.titleMedium),
                    if (nextDay)
                      Text(S.nextDay,
                          style: t.bodySmall?.copyWith(fontSize: 11)),
                  ],
                ),
              ),
              Icon(AppIcons.dropdown, color: AppColors.inkMuted),
            ],
          ),
        ),
      ),
    );
  }
}
