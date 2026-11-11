import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_strings.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/widgets/widgets.dart';
import '../owner_providers.dart';

class OwnerShell extends ConsumerWidget {
  const OwnerShell({super.key, required this.shell});
  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pending = ref.watch(ownerRequestsProvider).valueOrNull?.length ?? 0;
    return Scaffold(
      extendBody: true,
      body: shell,
      bottomNavigationBar: GlassNavBar(
        currentIndex: shell.currentIndex,
        onTap: (i) =>
            shell.goBranch(i, initialLocation: i == shell.currentIndex),
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
              badge: pending),
          const GlassNavItem(
              icon: AppIcons.profile,
              selectedIcon: AppIcons.profileFill,
              label: S.navProfile),
        ],
      ),
    );
  }
}
