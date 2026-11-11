import 'package:flutter/material.dart';
import 'package:ma3adna/core/theme/app_spacing.dart';
import 'package:ma3adna/core/theme/app_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_mode.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/widgets.dart';
import '../../data/models/models.dart';
import '../auth/session_controller.dart';

/// Profile & settings. Shared by both roles via [extra] sections.
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key, this.extra = const []});

  /// Role-specific widgets shown above the settings list.
  final List<Widget> extra;

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _notifications = true;

  Future<void> _editName(AppUser user) async {
    final controller = TextEditingController(text: user.name);
    final name = await showAppBottomSheet<String>(
      context,
      title: S.editName,
      builder: (ctx) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
              controller: controller, hint: S.fullNameHint, autofocus: true),
          const SizedBox(height: 16),
          PrimaryButton(
            label: S.save,
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
          ),
        ],
      ),
    );
    if (name != null && name.isNotEmpty) {
      await ref.read(sessionProvider.notifier).updateName(name);
    }
  }

  Future<void> _logout() async {
    final ok = await showConfirmSheet(context,
        title: S.logoutQ, confirmLabel: S.logout, destructive: true);
    if (ok) await ref.read(sessionProvider.notifier).signOut();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(sessionProvider);
    if (user == null) return const SizedBox.shrink();
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text(S.profile)),
      body: ListView(
        padding:
            const EdgeInsets.fromLTRB(20, 8, 20, AppSpacing.navBarClearance),
        children: [
          AppPanel(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.primaryLight,
                  child: Text(
                      user.name.isEmpty ? '' : user.name.characters.first,
                      style:
                          t.headlineMedium?.copyWith(color: AppColors.primary)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name, style: t.titleLarge),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(Fmt.phone(user.phone),
                            style: t.bodyLarge
                                ?.copyWith(color: AppColors.inkMuted)),
                      ),
                      Text(user.role == UserRole.owner ? S.owner : S.player,
                          style: t.bodySmall?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: S.editName,
                  onPressed: () => _editName(user),
                  icon: const Icon(AppIcons.edit),
                ),
              ],
            ),
          ),
          ...widget.extra,
          const SizedBox(height: 16),
          AppPanel(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(AppIcons.appearance,
                        size: 20, color: AppColors.inkMuted),
                    const SizedBox(width: 10),
                    Text(S.appearance, style: t.bodyLarge),
                  ],
                ),
                const SizedBox(height: 10),
                SegmentedButton<ThemeMode>(
                  showSelectedIcon: false,
                  style: SegmentedButton.styleFrom(
                    selectedForegroundColor: AppColors.primary,
                    minimumSize: const Size.fromHeight(42),
                  ),
                  segments: const [
                    ButtonSegment(
                        value: ThemeMode.system,
                        icon: Icon(AppIcons.themeAuto, size: 18),
                        label: Text(S.themeSystem)),
                    ButtonSegment(
                        value: ThemeMode.light,
                        icon: Icon(AppIcons.themeLight, size: 18),
                        label: Text(S.themeLight)),
                    ButtonSegment(
                        value: ThemeMode.dark,
                        icon: Icon(AppIcons.themeDark, size: 18),
                        label: Text(S.themeDark)),
                  ],
                  selected: {ref.watch(themeModeProvider)},
                  onSelectionChanged: (s) =>
                      ref.read(themeModeProvider.notifier).state = s.first,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppPanel(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                SwitchListTile(
                  value: _notifications,
                  onChanged: (v) => setState(() => _notifications = v),
                  activeColor: AppColors.primary,
                  secondary: const Icon(AppIcons.bell),
                  title: const Text(S.notifications),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(AppIcons.language),
                  title: const Text(S.language),
                  trailing: Text(S.arabic, style: t.bodyMedium),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(AppIcons.support),
                  title: const Text(S.helpCenter),
                  trailing: const Icon(AppIcons.forward),
                  onTap: () => showSnack(context, S.comingSoon),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(AppIcons.terms),
                  title: const Text(S.terms),
                  trailing: const Icon(AppIcons.forward),
                  onTap: () => showSnack(context, S.comingSoon),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SecondaryButton(
            label: S.logout,
            icon: AppIcons.logout,
            color: AppColors.error,
            onPressed: _logout,
          ),
          const SizedBox(height: 12),
          Text(S.appVersion, style: t.bodySmall, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
