part of 'owner_shell_imports.dart';

class OwnerShell extends ConsumerWidget {
  const OwnerShell({super.key, required this.shell});
  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = OwnerShellController(shell);
    final pending = ref.watch(ownerRequestsProvider).valueOrNull?.length ?? 0;
    return Scaffold(
      extendBody: true,
      body: shell,
      bottomNavigationBar: OwnerNavBar(
        currentIndex: shell.currentIndex,
        pendingRequests: pending,
        onTap: controller.selectTab,
      ),
    );
  }
}
