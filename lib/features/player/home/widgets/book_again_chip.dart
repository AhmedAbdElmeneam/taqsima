part of 'player_home_widgets_imports.dart';

/// Pill with the pitch thumbnail and name.
class BookAgainChip extends StatelessWidget {
  const BookAgainChip({super.key, required this.pitch, required this.onTap});

  final Pitch pitch;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      child: Material(
        color: AppColors.card,
        shape: StadiumBorder(side: BorderSide(color: AppColors.borderSoft)),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(5, 5, 12, 5),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                PitchThumb(
                    photoKey: pitch.coverPhoto,
                    size: 28,
                    radius: AppSpacing.radius),
                const SizedBox(width: 8),
                Text(pitch.name,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(width: 4),
                Icon(AppIcons.history, size: 14, color: AppColors.inkMuted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
