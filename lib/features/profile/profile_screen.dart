part of 'profile_imports.dart';

/// Profile & settings. Shared by both roles via [extra] sections.
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key, this.extra = const []});

  /// Role-specific widgets shown above the settings list.
  final List<Widget> extra;

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late final ProfileController controller = ProfileController(ref);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(sessionProvider);
    if (user == null) return const SizedBox.shrink();

    return TabPage(
      child: ListView(
        padding:
            const EdgeInsets.fromLTRB(20, 0, 20, AppSpacing.navBarClearance),
        children: [
          const PageTitle(S.profile,
              padding: EdgeInsets.only(top: 12, bottom: 12)),
          ProfileUserCard(
            user: user,
            onEditName: () => controller.editName(context, user),
          ),
          ...widget.extra,
          const SizedBox(height: 16),
          AppearancePanel(
            mode: ref.watch(themeModeProvider),
            onChanged: controller.setThemeMode,
          ),
          const SizedBox(height: 12),
          SettingsPanel(
            notifications: controller.notifications,
            onHelp: () => controller.comingSoon(context),
            onTerms: () => controller.comingSoon(context),
          ),
          const SizedBox(height: 20),
          SecondaryButton(
            label: S.logout,
            icon: AppIcons.logout,
            color: AppColors.error,
            onPressed: () => controller.logout(context),
          ),
          const SizedBox(height: 12),
          Text(S.appVersion,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
