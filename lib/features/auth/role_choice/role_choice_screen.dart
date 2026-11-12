part of 'role_choice_imports.dart';

/// Splash (brief brand moment) that reveals the role choice.
class RoleChoiceScreen extends StatefulWidget {
  const RoleChoiceScreen({super.key});

  @override
  State<RoleChoiceScreen> createState() => _RoleChoiceScreenState();
}

class _RoleChoiceScreenState extends State<RoleChoiceScreen> {
  final controller = RoleChoiceController();

  @override
  void initState() {
    super.initState();
    controller.start();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: ValueListenableBuilder<bool>(
          valueListenable: controller.showChoice,
          builder: (context, showChoice, _) => Column(
            children: [
              Expanded(child: RoleChoiceBrand(raised: showChoice)),
              RoleChoicePanel(
                visible: showChoice,
                onChoose: (role) => controller.chooseRole(context, role),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
