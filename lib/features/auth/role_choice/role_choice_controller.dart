part of 'role_choice_imports.dart';

/// Splash timing and role navigation.
class RoleChoiceController {
  static const splashDuration = Duration(milliseconds: 1400);

  /// Becomes true once the brand moment is over and the choice slides in.
  final showChoice = ValueNotifier(false);

  bool _disposed = false;

  void start() {
    Future.delayed(splashDuration, () {
      if (!_disposed) showChoice.value = true;
    });
  }

  void chooseRole(BuildContext context, UserRole role) =>
      context.push(Routes.login(role));

  void dispose() {
    _disposed = true;
    showChoice.dispose();
  }
}
