import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_strings.dart';
import '../owner_providers.dart';

class OwnerShell extends ConsumerWidget {
  const OwnerShell({super.key, required this.shell});
  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pending = ref.watch(ownerRequestsProvider).valueOrNull?.length ?? 0;
    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (i) =>
            shell.goBranch(i, initialLocation: i == shell.currentIndex),
        destinations: [
          const NavigationDestination(
              icon: Icon(Icons.today_outlined),
              selectedIcon: Icon(Icons.today_rounded),
              label: S.navToday),
          const NavigationDestination(
              icon: Icon(Icons.calendar_view_week_outlined),
              selectedIcon: Icon(Icons.calendar_view_week_rounded),
              label: S.navCalendar),
          NavigationDestination(
              icon: Badge(
                isLabelVisible: pending > 0,
                label: Text('$pending'),
                child: const Icon(Icons.inbox_outlined),
              ),
              selectedIcon: Badge(
                isLabelVisible: pending > 0,
                label: Text('$pending'),
                child: const Icon(Icons.inbox_rounded),
              ),
              label: S.navRequests),
          const NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded),
              label: S.navProfile),
        ],
      ),
    );
  }
}
