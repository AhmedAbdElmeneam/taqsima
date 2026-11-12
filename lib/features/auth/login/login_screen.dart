part of 'login_imports.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key, required this.role});
  final UserRole role;

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late final LoginController controller = LoginController(ref, widget.role);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Form(
          key: controller.formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              LoginHeader(isOwner: controller.isOwner),
              const SizedBox(height: 24),
              LoginModeSwitch(isSignup: controller.isSignup),
              const SizedBox(height: 24),
              LoginFields(
                isSignup: controller.isSignup,
                name: controller.name,
                phone: controller.phone,
                validateName: controller.validateName,
                validatePhone: controller.validatePhone,
              ),
              const SizedBox(height: 28),
              LoginSubmitButton(
                loading: controller.loading,
                onPressed: () => controller.submit(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
