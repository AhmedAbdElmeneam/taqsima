part of 'owner_shell_imports.dart';

/// Tab switching for the owner bottom navigation.
class OwnerShellController {
  OwnerShellController(this.shell);
  final StatefulNavigationShell shell;

  void selectTab(int i) => shell.selectTab(i);
}
