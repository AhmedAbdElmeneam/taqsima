part of 'profile_widgets_imports.dart';

/// Notifications, language, help and terms.
class SettingsPanel extends StatelessWidget {
  const SettingsPanel({
    super.key,
    required this.notifications,
    required this.onHelp,
    required this.onTerms,
  });

  final ValueNotifier<bool> notifications;
  final VoidCallback onHelp;
  final VoidCallback onTerms;

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: notifications,
            builder: (context, on, _) => SwitchListTile(
              value: on,
              onChanged: (v) => notifications.value = v,
              activeColor: AppColors.primary,
              secondary: const Icon(AppIcons.bell),
              title: const Text(S.notifications),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(AppIcons.language),
            title: const Text(S.language),
            trailing:
                Text(S.arabic, style: Theme.of(context).textTheme.bodyMedium),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(AppIcons.support),
            title: const Text(S.helpCenter),
            trailing: const Icon(AppIcons.forward),
            onTap: onHelp,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(AppIcons.terms),
            title: const Text(S.terms),
            trailing: const Icon(AppIcons.forward),
            onTap: onTerms,
          ),
        ],
      ),
    );
  }
}
