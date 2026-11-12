part of 'owner_profile_imports.dart';

/// Owner profile: shared profile/settings + "my pitches" with their status.
class OwnerProfileScreen extends ConsumerWidget {
  const OwnerProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = OwnerProfileController();
    final pitches = ref.watch(ownerPitchesProvider);

    return ProfileScreen(extra: [
      const SizedBox(height: 20),
      MyPitchesSection(
        onAdd: () => controller.addPitch(context),
        child: AsyncView(
          value: pitches,
          builder: (list) => Column(
            children: [
              for (final p in list) ...[
                OwnerPitchCard(
                  pitch: p,
                  onEdit: () => controller.editPitch(context, p),
                  onHours: () => controller.editHours(context, p),
                ),
                const SizedBox(height: 10),
              ],
            ],
          ),
        ),
      ),
    ]);
  }
}
