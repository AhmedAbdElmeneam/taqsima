part of 'weekly_calendar_widgets_imports.dart';

/// ‹ date range › ; a null callback disables that arrow. Tapping the date
/// range opens a month calendar to jump to any day.
class WeekNavigator extends StatelessWidget {
  const WeekNavigator({
    super.key,
    required this.start,
    required this.end,
    required this.onPrevious,
    required this.onNext,
    required this.onPickDate,
  });

  final DateTime start;
  final DateTime end;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final VoidCallback onPickDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
      child: Row(
        children: [
          IconButton.outlined(
            onPressed: onPrevious,
            icon: const Icon(AppIcons.backward),
          ),
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              onTap: onPickDate,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(AppIcons.calendar,
                        size: 20, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        '${start.day} ${S.months[start.month - 1]} - ${end.day} ${S.months[end.month - 1]}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          IconButton.outlined(
            onPressed: onNext,
            icon: const Icon(AppIcons.forward),
          ),
        ],
      ),
    );
  }
}
