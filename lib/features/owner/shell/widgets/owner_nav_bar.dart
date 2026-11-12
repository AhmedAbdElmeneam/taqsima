part of 'owner_shell_widgets_imports.dart';

/// Today / calendar / requests (with badge) / profile.
class OwnerNavBar extends StatelessWidget {
  const OwnerNavBar({
    super.key,
    required this.currentIndex,
    required this.pendingRequests,
    required this.onTap,
  });

  final int currentIndex;
  final int pendingRequests;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return GlassNavBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        const GlassNavItem(
            icon: AppIcons.today,
            selectedIcon: AppIcons.todayFill,
            label: S.navToday),
        const GlassNavItem(
            icon: AppIcons.week,
            selectedIcon: AppIcons.weekFill,
            label: S.navCalendar),
        GlassNavItem(
            icon: AppIcons.inbox,
            selectedIcon: AppIcons.inboxFill,
            label: S.navRequests,
            badge: pendingRequests),
        const GlassNavItem(
            icon: AppIcons.profile,
            selectedIcon: AppIcons.profileFill,
            label: S.navProfile),
      ],
    );
  }
}
