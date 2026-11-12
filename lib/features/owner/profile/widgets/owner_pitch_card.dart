part of 'owner_profile_widgets_imports.dart';

/// Pitch thumb, name, area, status and edit / hours buttons.
class OwnerPitchCard extends StatelessWidget {
  const OwnerPitchCard({
    super.key,
    required this.pitch,
    required this.onEdit,
    required this.onHours,
  });

  final Pitch pitch;
  final VoidCallback onEdit;
  final VoidCallback onHours;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final p = pitch;
    return AppPanel(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              PitchThumb(
                  photoKey: p.coverPhoto,
                  size: 54,
                  radius: AppSpacing.radiusSm),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.name, style: t.titleMedium),
                    Text(p.area,
                        style:
                            t.bodyMedium?.copyWith(color: AppColors.inkMuted)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text('${S.pitchStatus}: ', style: t.bodySmall),
                        PitchStatusBadge(status: p.status),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (p.status == PitchStatus.pending)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(S.underReviewHint, style: t.bodySmall),
            ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: SmallOutlinedButton(
                    icon: AppIcons.edit, label: S.edit, onPressed: onEdit),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SmallOutlinedButton(
                    icon: AppIcons.clock, label: S.hours, onPressed: onHours),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
