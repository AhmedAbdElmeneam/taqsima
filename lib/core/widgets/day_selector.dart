import 'package:flutter/material.dart';

import '../l10n/app_strings.dart';
import '../theme/app_colors.dart';
import '../utils/formatters.dart';

/// Horizontal strip of day tiles starting today.
class DaySelector extends StatelessWidget {
  const DaySelector({
    super.key,
    required this.selected,
    required this.onSelected,
    this.days = 14,
    this.start,
  });

  final DateTime selected;
  final ValueChanged<DateTime> onSelected;
  final int days;
  final DateTime? start;

  @override
  Widget build(BuildContext context) {
    final first = Fmt.dateOnly(start ?? DateTime.now());
    final today = Fmt.dateOnly(DateTime.now());
    final t = Theme.of(context).textTheme;
    return SizedBox(
      height: 84,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: days,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final day = first.add(Duration(days: i));
          final isSelected = Fmt.isSameDay(day, selected);
          final isToday = Fmt.isSameDay(day, today);
          return Material(
            color: isSelected ? AppColors.primary : AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: 1.5),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => onSelected(day),
              child: SizedBox(
                width: 66,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isToday ? S.today : S.weekdaysShort[Fmt.dayOfWeek(day)],
                      style: t.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : AppColors.inkMuted,
                      ),
                    ),
                    Text(
                      '${day.day}',
                      style: t.headlineMedium?.copyWith(
                        fontSize: 24,
                        height: 1.2,
                        color: isSelected ? Colors.white : AppColors.ink,
                      ),
                    ),
                    Text(
                      S.months[day.month - 1],
                      style: t.bodySmall?.copyWith(
                        fontSize: 11,
                        color: isSelected ? Colors.white70 : AppColors.inkFaint,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
