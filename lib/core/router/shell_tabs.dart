import 'package:go_router/go_router.dart';

extension ShellTabs on StatefulNavigationShell {
  /// Switches tab; tapping the current tab again returns it to its first page.
  void selectTab(int index) =>
      goBranch(index, initialLocation: index == currentIndex);
}
