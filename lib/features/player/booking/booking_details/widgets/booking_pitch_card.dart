part of 'player_booking_details_widgets_imports.dart';

/// Pitch photo, name and area; opens the pitch page.
class BookingPitchCard extends StatelessWidget {
  const BookingPitchCard({super.key, required this.pitch, required this.onTap});

  final Pitch pitch;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PitchImage(photoKey: pitch.coverPhoto, height: 110),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(pitch.name, style: t.titleMedium),
                        Text(pitch.area,
                            style: t.bodyMedium
                                ?.copyWith(color: AppColors.inkMuted)),
                      ],
                    ),
                  ),
                  Icon(AppIcons.forward, color: AppColors.inkFaint),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
