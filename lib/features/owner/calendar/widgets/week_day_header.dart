part of 'weekly_calendar_widgets_imports.dart';

/// Weekday + day number; today is filled green.
class WeekDayHeader extends StatelessWidget {
  const WeekDayHeader(
      {super.key, required this.day, required this.isToday, required this.width});

  final DateTime day;
  final bool isToday;
  final double width;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      width: width,
      margin: const EdgeInsets.all(2),
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: isToday ? AppColors.primary : AppColors.card,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(
            isToday ? S.today : S.weekdaysShort[Fmt.dayOfWeek(day)],
            style: t.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: isToday ? Colors.white : AppColors.inkMuted),
          ),
          Text('${day.day}',
              style: t.titleMedium
                  ?.copyWith(color: isToday ? Colors.white : AppColors.ink)),
        ],
      ),
    );
  }
}
