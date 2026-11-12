part of 'player_home_widgets_imports.dart';

/// Small photo card: pitch, start time and price of one free slot.
class AvailableSlotCard extends StatelessWidget {
  const AvailableSlotCard({
    super.key,
    required this.pitch,
    required this.slot,
    required this.onTap,
  });

  final Pitch pitch;
  final TimeSlot slot;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return SizedBox(
      width: 150,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  PitchImage(photoKey: pitch.coverPhoto, height: 72),
                  PositionedDirectional(
                    bottom: 6,
                    start: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusLg),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(AppIcons.clock,
                              size: 12, color: AppColors.onPhotoInk),
                          const SizedBox(width: 3),
                          Text(Fmt.time(slot.startAt),
                              style: t.bodySmall?.copyWith(
                                  color: AppColors.onPhotoInk,
                                  fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 6, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(pitch.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: t.titleMedium),
                    Text(S.price(slot.price),
                        style: t.bodySmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
