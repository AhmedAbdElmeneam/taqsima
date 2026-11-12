part of 'pitch_details_imports.dart';

class PitchDetailsScreen extends ConsumerWidget {
  const PitchDetailsScreen({super.key, required this.pitchId});
  final String pitchId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = PitchDetailsController(pitchId);
    final pitch = ref.watch(pitchProvider(pitchId));
    final loaded = pitch.valueOrNull;

    return Scaffold(
      body: AsyncView(
        value: pitch,
        builder: (p) => p == null
            ? const EmptyState(icon: AppIcons.pitch, title: S.noResults)
            : PitchDetailsBody(pitch: p),
      ),
      bottomNavigationBar: loaded == null
          ? null
          : PitchBookBar(
              pricePerHour: loaded.pricePerHour,
              onBook: () => controller.openSlots(context),
            ),
    );
  }
}
