import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/labels.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../data/models/models.dart';

/// Today's occupancy: one animated bar split by booking type.
class OccupancyMeter extends StatelessWidget {
  const OccupancyMeter({super.key, required this.slots});
  final List<TimeSlot> slots;

  @override
  Widget build(BuildContext context) {
    if (slots.isEmpty) return const SizedBox.shrink();
    final t = Theme.of(context).textTheme;
    final total = slots.length;
    int count(SlotState s) => slots.where((x) => x.state == s).length;
    final app = count(SlotState.appBooked);
    final manual = count(SlotState.manualBooked);
    final blocked = count(SlotState.blocked);
    final used = app + manual + blocked;
    final percent = (used / total * 100).round();

    final parts = [
      (app, SlotState.appBooked.color),
      (manual, SlotState.manualBooked.color),
      (blocked, SlotState.blocked.color),
    ];

    return AppPanel(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(AppIcons.today, size: 18, color: AppColors.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(S.occupancyToday, style: t.titleMedium),
                    Text(S.bookedOf(used, total), style: t.bodySmall),
                  ],
                ),
              ),
              CountUp(
                value: percent,
                format: (v) => Fmt.ltr('$v%'),
                style: t.titleLarge?.copyWith(color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Grows from empty to its value once when the screen opens.
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 900),
            curve: Motion.curve,
            builder: (_, v, __) => ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
              child: SizedBox(
                height: 10,
                child: Container(
                  color: AppColors.primaryLight,
                  child: Row(
                    children: [
                      for (final (n, color) in parts)
                        if (n > 0)
                          Expanded(
                            flex: (n * 1000 * v).round().clamp(1, 1 << 30),
                            child: Container(color: color),
                          ),
                      Expanded(
                        flex: ((total - used * v) * 1000)
                            .round()
                            .clamp(1, 1 << 30),
                        child: const SizedBox(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 4,
            children: [
              for (final s in [
                SlotState.appBooked,
                SlotState.manualBooked,
                SlotState.blocked
              ])
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration:
                          BoxDecoration(color: s.color, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 4),
                    Text('${s.label} ${count(s)}', style: t.bodySmall),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
