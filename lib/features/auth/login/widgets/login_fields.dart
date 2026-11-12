part of 'login_widgets_imports.dart';

/// Name (sign-up only) and Egyptian mobile number fields.
class LoginFields extends StatelessWidget {
  const LoginFields({
    super.key,
    required this.isSignup,
    required this.name,
    required this.phone,
    required this.validateName,
    required this.validatePhone,
  });

  final ValueNotifier<bool> isSignup;
  final TextEditingController name;
  final TextEditingController phone;
  final FormFieldValidator<String> validateName;
  final FormFieldValidator<String> validatePhone;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder<bool>(
          valueListenable: isSignup,
          builder: (context, signup, _) => AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: signup
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: AppTextField(
                      label: S.fullName,
                      hint: S.fullNameHint,
                      controller: name,
                      prefixIcon: AppIcons.profile,
                      textInputAction: TextInputAction.next,
                      validator: validateName,
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ),
        AppTextField(
          label: S.phoneNumber,
          hint: S.phoneHint,
          controller: phone,
          prefixIcon: AppIcons.mobile,
          keyboardType: TextInputType.phone,
          textDirection: TextDirection.ltr,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(11),
          ],
          validator: validatePhone,
        ),
      ],
    );
  }
}
