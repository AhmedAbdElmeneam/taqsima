import 'package:flutter/material.dart';

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
                color: color, fontWeight: FontWeight.w800, fontSize: 13),
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
        PitchStatus.active => const AppBadge(
            label: S.active,
            color: AppColors.success,
            background: AppColors.successLight,
            icon: Icons.verified_rounded),
        PitchStatus.pending => const AppBadge(
            label: S.underReview,
            color: AppColors.slotManual,
            background: AppColors.warningLight,
            icon: Icons.schedule_rounded),
      };
}
