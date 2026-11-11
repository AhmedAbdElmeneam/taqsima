import 'package:flutter/material.dart';
import 'package:ma3adna/core/theme/app_icons.dart';

import '../../data/models/models.dart';
import '../l10n/app_strings.dart';
import '../theme/app_colors.dart';
import '../utils/labels.dart';

/// Generic pill badge.
class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.label,
    required this.color,
    required this.background,
    this.icon,
  });

  final String label;
  final Color color;
  final Color background;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color, fontWeight: FontWeight.w700, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class BookingStatusBadge extends StatelessWidget {
  const BookingStatusBadge({super.key, required this.status});
  final BookingStatus status;

  @override
  Widget build(BuildContext context) => AppBadge(
        label: status.label,
        color: status.color,
        background: status.background,
        icon: status.icon,
      );
}

class PitchStatusBadge extends StatelessWidget {
  const PitchStatusBadge({super.key, required this.status});
  final PitchStatus status;

  @override
  Widget build(BuildContext context) => switch (status) {
        PitchStatus.active => AppBadge(
            label: S.active,
            color: AppColors.success,
            background: AppColors.successLight,
            icon: AppIcons.verified),
        PitchStatus.pending => AppBadge(
            label: S.underReview,
            color: AppColors.pending,
            background: AppColors.warningLight,
            icon: AppIcons.clock),
      };
}
