part of 'player_shell_imports.dart';

/// Tab switching for the player bottom navigation.
class PlayerShellController {
  PlayerShellController(this.shell);
  final StatefulNavigationShell shell;

  void selectTab(int i) => shell.selectTab(i);
}
