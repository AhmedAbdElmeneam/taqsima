part of 'booking_confirm_widgets_imports.dart';

/// Pitch photo with its name on top.
class ConfirmPitchBanner extends StatelessWidget {
  const ConfirmPitchBanner({super.key, required this.pitch});
  final Pitch pitch;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: Stack(
        children: [
          PitchImage(photoKey: pitch.coverPhoto, height: 120),
          PositionedDirectional(
            bottom: 12,
            start: 16,
            child: Text(pitch.name,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
