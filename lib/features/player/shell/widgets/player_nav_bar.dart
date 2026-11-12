part of 'player_shell_widgets_imports.dart';

/// Home / search / bookings / profile.
class PlayerNavBar extends StatelessWidget {
  const PlayerNavBar(
      {super.key, required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return GlassNavBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        GlassNavItem(
            icon: AppIcons.home,
            selectedIcon: AppIcons.homeFill,
            label: S.navHome),
        GlassNavItem(
            icon: AppIcons.search,
            selectedIcon: AppIcons.searchFill,
            label: S.navSearch),
        GlassNavItem(
            icon: AppIcons.bookings,
            selectedIcon: AppIcons.bookingsFill,
            label: S.navMyBookings),
        GlassNavItem(
            icon: AppIcons.profile,
            selectedIcon: AppIcons.profileFill,
            label: S.navProfile),
      ],
    );
  }
}
