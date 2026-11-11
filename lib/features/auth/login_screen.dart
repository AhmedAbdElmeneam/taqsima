import 'package:flutter/material.dart';
import 'package:ma3adna/core/theme/app_icons.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/widgets.dart';
import '../../data/models/models.dart';
import 'session_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key, required this.role});
  final UserRole role;

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phone = TextEditingController();
  final _name = TextEditingController();
  bool _isSignup = false;
  bool _loading = false;

  @override
  void dispose() {
    _phone.dispose();
    _name.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await ref.read(sessionProvider.notifier).requestOtp(_phone.text);
      if (!mounted) return;
      context.push(Routes.otp,
          extra: OtpArgs(
            phone: _phone.text,
            role: widget.role,
            name: _isSignup ? _name.text : null,
          ));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final isOwner = widget.role == UserRole.owner;
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Icon(isOwner ? AppIcons.owner : AppIcons.player,
                  size: 40, color: AppColors.primary),
              const SizedBox(height: 8),
              Text(isOwner ? S.loginAsOwner : S.loginAsPlayer,
                  style: t.headlineMedium, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: false, label: Text(S.login)),
                  ButtonSegment(value: true, label: Text(S.signup)),
                ],
                selected: {_isSignup},
                showSelectedIcon: false,
                style: SegmentedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  selectedBackgroundColor: AppColors.primaryLight,
                  selectedForegroundColor: AppColors.primaryDark,
                  textStyle: t.titleMedium,
                ),
                onSelectionChanged: (s) => setState(() => _isSignup = s.first),
              ),
              const SizedBox(height: 24),
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                child: _isSignup
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: AppTextField(
                          label: S.fullName,
                          hint: S.fullNameHint,
                          controller: _name,
                          prefixIcon: AppIcons.profile,
                          textInputAction: TextInputAction.next,
                          validator: (v) =>
                              _isSignup && (v ?? '').trim().isEmpty
                                  ? S.nameRequired
                                  : null,
                        ),
                      )
                    : const SizedBox(width: double.infinity),
              ),
              AppTextField(
                label: S.phoneNumber,
                hint: S.phoneHint,
                controller: _phone,
                prefixIcon: AppIcons.mobile,
                keyboardType: TextInputType.phone,
                textDirection: TextDirection.ltr,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
                validator: (v) => RegExp(r'^01[0125]\d{8}$').hasMatch(v ?? '')
                    ? null
                    : S.invalidPhone,
              ),
              const SizedBox(height: 28),
              PrimaryButton(
                label: S.sendCode,
                icon: AppIcons.sms,
                loading: _loading,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
