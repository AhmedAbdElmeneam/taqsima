part of 'working_hours_widgets_imports.dart';

/// Weekday name, open switch and from / to buttons.
class DayHoursRow extends StatelessWidget {
  const DayHoursRow({
    super.key,
    required this.name,
    required this.day,
    required this.onToggle,
    required this.onFrom,
    required this.onTo,
  });

  final String name;
  final DayHours day;
  final ValueChanged<bool> onToggle;
  final VoidCallback onFrom;
  final VoidCallback onTo;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return AppPanel(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text(name, style: t.titleMedium)),
              Text(day.open ? S.open : S.closed,
                  style: t.bodyMedium?.copyWith(
                      color: day.open ? AppColors.primary : AppColors.inkFaint,
                      fontWeight: FontWeight.w700)),
              Switch(
                value: day.open,
                activeColor: AppColors.primary,
                onChanged: onToggle,
              ),
            ],
          ),
          if (day.open)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TimeButton(
                        label: S.from, minutes: day.from, onTap: onFrom),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TimeButton(
                      label: S.to,
                      minutes: day.to,
                      nextDay: day.to <= day.from,
                      onTap: onTo,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
