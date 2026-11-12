part of 'weekly_calendar_widgets_imports.dart';

/// One filter pill; [state] null = "all".
class CalendarFilterChip extends StatelessWidget {
  const CalendarFilterChip({
    super.key,
    required this.state,
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final SlotState? state;
  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final st = state;
    final color = st?.color ?? AppColors.ink;
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: selected
              ? (st?.background ?? AppColors.primaryLight)
              : AppColors.card,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
              color: selected ? color.withOpacity(.6) : AppColors.borderSoft),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(st?.icon ?? AppIcons.funnel, size: 16, color: color),
                const SizedBox(width: 6),
                Text(
                  S.filterCount(label, count),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: selected ? color : AppColors.ink,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
