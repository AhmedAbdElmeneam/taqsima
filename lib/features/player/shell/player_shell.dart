part of 'player_shell_imports.dart';

class PlayerShell extends StatelessWidget {
  const PlayerShell({super.key, required this.shell});
  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final controller = PlayerShellController(shell);
    return Scaffold(
      extendBody: true,
      body: shell,
      bottomNavigationBar: PlayerNavBar(
        currentIndex: shell.currentIndex,
        onTap: controller.selectTab,
      ),
    );
  }
}
