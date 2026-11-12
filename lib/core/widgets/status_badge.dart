import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import '../theme/app_icons.dart';

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

/// Full-width tinted banner at the top of a booking's details screen.
class BookingStatusBanner extends StatelessWidget {
  const BookingStatusBanner({super.key, required this.status, this.message});
  final BookingStatus status;

  /// Optional explanation under the status (e.g. "waiting for the owner").
  final String? message;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: status.background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: status.color.withOpacity(.25)),
      ),
      child: Row(
        children: [
          Icon(status.icon, color: status.color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(status.label,
                    style: t.titleLarge?.copyWith(color: status.color)),
                if (message != null) Text(message!, style: t.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
