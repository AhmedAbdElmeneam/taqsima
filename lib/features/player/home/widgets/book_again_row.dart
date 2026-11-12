part of 'player_home_widgets_imports.dart';

/// Chips for pitches the player has played at before.
class BookAgainRow extends StatelessWidget {
  const BookAgainRow({super.key, required this.pitches, required this.onTap});

  final List<Pitch> pitches;
  final ValueChanged<Pitch> onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(title: S.bookAgain),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final (i, p) in pitches.indexed)
              FadeSlideIn(
                index: i,
                child: BookAgainChip(pitch: p, onTap: () => onTap(p)),
              ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
