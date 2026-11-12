part of 'owner_profile_imports.dart';

/// Pitch management shortcuts on the owner profile.
class OwnerProfileController {
  OwnerProfileController(this.ref);
  final WidgetRef ref;

  void addPitch(BuildContext context) => context.push(Routes.ownerPitchForm);

  void editPitch(BuildContext context, Pitch p) =>
      context.push(Routes.ownerEditPitch(p.id));

  void editHours(BuildContext context, Pitch p) =>
      context.push(Routes.ownerHours(p.id));

  /// Quick theme switch without going through the whole pitch form. The
  /// pitch becomes the managed one so the owner sees the new look at once.
  Future<void> changeTheme(BuildContext context, Pitch p) async {
    final picked = await showAppBottomSheet<PitchTheme>(
      context,
      title: S.pitchTheme,
      builder: (ctx) => SingleChildScrollView(
        child: PitchThemeGrid(
          selected: p.theme,
          onSelect: (t) => Navigator.pop(ctx, t),
        ),
      ),
    );
    if (picked == null || picked == p.theme) return;
    await ref.read(pitchRepositoryProvider).savePitch(p.copyWith(theme: picked));
    ref.read(selectedPitchIdProvider.notifier).state = p.id;
    ref.refreshData();
    if (context.mounted) showSnack(context, S.themeSaved);
  }
}
