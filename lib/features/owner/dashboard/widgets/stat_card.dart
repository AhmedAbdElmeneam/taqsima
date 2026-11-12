import 'package:flutter/material.dart';

import '../../../../core/l10n/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';

/// Small figure card on the owner home (revenue, bookings, free slots).
class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.highlight = false,
    this.amount,
  });

  final String label;
  final String value;
  final IconData icon;
  final bool highlight;

  /// When set, the number counts up from 0 (formatted as a price).
  final int? amount;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final fg = highlight ? Colors.white : AppColors.ink;
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: highlight ? null : AppColors.card,
        gradient: highlight
            ? LinearGradient(
                begin: AlignmentDirectional.topStart,
                end: AlignmentDirectional.bottomEnd,
                colors: [AppColors.primary, AppColors.primaryDark],
              )
            : null,
        borderRadius: BorderRadius.circular(18),
        border: highlight ? null : Border.all(color: AppColors.borderSoft),
        boxShadow: softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon,
                  size: 16,
                  color: highlight ? Colors.white70 : AppColors.primary),
              const SizedBox(width: 6),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: amount == null
                      ? Text(value,
                          style:
                              t.titleLarge?.copyWith(color: fg, fontSize: 16))
                      : CountUp(
                          value: amount!,
                          format: S.price,
                          style:
                              t.titleLarge?.copyWith(color: fg, fontSize: 16)),
                ),
              ),
            ],
          ),
          Text(label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: t.bodySmall?.copyWith(
                  color: highlight ? Colors.white70 : AppColors.inkMuted)),
        ],
      ),
    );
  }
}
