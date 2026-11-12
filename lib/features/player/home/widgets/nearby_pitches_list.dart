part of 'player_home_widgets_imports.dart';

/// Pitch cards with a distance badge.
class NearbyPitchesList extends StatelessWidget {
  const NearbyPitchesList({
    super.key,
    required this.pitches,
    required this.distanceOf,
    required this.onTap,
  });

  final List<Pitch> pitches;
  final double Function(Pitch) distanceOf;
  final ValueChanged<Pitch> onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final (i, p) in pitches.indexed) ...[
          FadeSlideIn(
            index: i,
            child: PitchCard(
              pitch: p,
              trailing: DistanceBadge(km: distanceOf(p)),
              onTap: () => onTap(p),
            ),
          ),
          const SizedBox(height: 14),
        ],
      ],
    );
  }
}
