part of 'pitch_details_widgets_imports.dart';

/// Name, type badge and area.
class PitchInfoHeader extends StatelessWidget {
  const PitchInfoHeader({super.key, required this.pitch});
  final Pitch pitch;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: Text(pitch.name, style: t.headlineMedium)),
            AppBadge(
              label: pitch.type.label,
              color: AppColors.primaryDark,
              background: AppColors.primaryLight,
              icon: AppIcons.team,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(AppIcons.location, color: AppColors.inkMuted, size: 20),
            const SizedBox(width: 4),
            Text(pitch.area,
                style: t.bodyLarge?.copyWith(color: AppColors.inkMuted)),
          ],
        ),
      ],
    );
  }
}
