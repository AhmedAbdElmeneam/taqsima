part of 'player_home_widgets_imports.dart';

/// Horizontal strip: the earliest free slot today at nearby pitches.
class AvailableTodayStrip extends StatelessWidget {
  const AvailableTodayStrip(
      {super.key, required this.items, required this.onTap});

  final List<(Pitch, TimeSlot)> items;
  final void Function(Pitch pitch, TimeSlot slot) onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          title: S.availableToday,
          leading: PulseDot(color: AppColors.primary, size: 7),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) {
              final (pitch, slot) = items[i];
              return FadeSlideIn(
                index: i,
                child: PressableScale(
                  child: AvailableSlotCard(
                    pitch: pitch,
                    slot: slot,
                    onTap: () => onTap(pitch, slot),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
