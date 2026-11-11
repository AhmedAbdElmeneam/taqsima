import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_strings.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/widgets/widgets.dart';

class PlayerShell extends StatelessWidget {
  const PlayerShell({super.key, required this.shell});
  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: shell,
      bottomNavigationBar: GlassNavBar(
        currentIndex: shell.currentIndex,
        onTap: (i) =>
            shell.goBranch(i, initialLocation: i == shell.currentIndex),
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
      ),
    );
  }
}
