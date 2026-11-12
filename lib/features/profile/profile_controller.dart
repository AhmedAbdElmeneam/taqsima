part of 'profile_imports.dart';

/// Profile edits, settings and sign-out (both roles).
class ProfileController {
  ProfileController(this.ref);

  final WidgetRef ref;

  /// Local only for now (no backend setting yet).
  final notifications = ValueNotifier(true);

  Future<void> editName(BuildContext context, AppUser user) async {
    final name = await showAppBottomSheet<String>(
      context,
      title: S.editName,
      builder: (_) => EditNameSheet(initialName: user.name),
    );
    if (name != null && name.isNotEmpty) {
      await ref.read(sessionProvider.notifier).updateName(name);
    }
  }

  void setThemeMode(ThemeMode mode) =>
      ref.read(themeModeProvider.notifier).state = mode;

  void comingSoon(BuildContext context) => showSnack(context, S.comingSoon);

  Future<void> logout(BuildContext context) async {
    final ok = await showConfirmSheet(context,
        title: S.logoutQ, confirmLabel: S.logout, destructive: true);
    if (ok) await ref.read(sessionProvider.notifier).signOut();
  }

  void dispose() => notifications.dispose();
}
