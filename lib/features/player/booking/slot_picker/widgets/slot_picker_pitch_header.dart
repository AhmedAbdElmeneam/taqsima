part of 'slot_picker_widgets_imports.dart';

/// Thumbnail, name, area and hourly price.
class SlotPickerPitchHeader extends StatelessWidget {
  const SlotPickerPitchHeader({super.key, required this.pitch});
  final Pitch pitch;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Row(
        children: [
          PitchThumb(photoKey: pitch.coverPhoto, size: 52, radius: 12),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pitch.name, style: t.titleMedium),
                Text('${pitch.area} • ${S.pricePerHour(pitch.pricePerHour)}',
                    style: t.bodyMedium?.copyWith(color: AppColors.inkMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
