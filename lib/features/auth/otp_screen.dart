import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/widgets.dart';
import 'session_controller.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key, required this.args});
  final OtpArgs args;

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  static const _length = 4;
  final _code = TextEditingController();
  final _focus = FocusNode();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _code.dispose();
    _focus.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    if (_code.text.length != _length) {
      setState(() => _error = S.otpIncomplete);
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      // On success the router redirects to the right home automatically.
      await ref.read(sessionProvider.notifier).verifyOtp(
            phone: widget.args.phone,
            code: _code.text,
            role: widget.args.role,
            name: widget.args.name,
          );
    } catch (_) {
      if (mounted) setState(() => _error = S.somethingWrong);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Icon(Icons.lock_outline_rounded,
                size: 56, color: AppColors.primary),
            const SizedBox(height: 8),
            Text(S.otpTitle,
                style: t.headlineMedium, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(S.otpSentTo(Fmt.phone(widget.args.phone)),
                style: t.bodyLarge?.copyWith(color: AppColors.inkMuted),
                textAlign: TextAlign.center),
            const SizedBox(height: 28),
            _OtpBoxes(
              controller: _code,
              focusNode: _focus,
              length: _length,
              hasError: _error != null,
              onCompleted: (_) => _verify(),
              onChanged: () => setState(() => _error = null),
            ),
            const SizedBox(height: 12),
            if (_error != null)
              Text(_error!,
                  textAlign: TextAlign.center,
                  style: t.bodyMedium?.copyWith(color: AppColors.error)),
            const SizedBox(height: 12),
            AppPanel(
              color: AppColors.infoLight,
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: AppColors.info),
                  const SizedBox(width: 8),
                  Expanded(
                      child: Text(S.otpDemoHint,
                          style:
                              t.bodyMedium?.copyWith(color: AppColors.info))),
                ],
              ),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
                label: S.verify, loading: _loading, onPressed: _verify),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => showSnack(context, S.codeResent),
              child: const Text(S.resendCode),
            ),
          ],
        ),
      ),
    );
  }
}

/// Four visual boxes driven by one hidden text field (LTR digits).
class _OtpBoxes extends StatelessWidget {
  const _OtpBoxes({
    required this.controller,
    required this.focusNode,
    required this.length,
    required this.hasError,
    required this.onCompleted,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final int length;
  final bool hasError;
  final ValueChanged<String> onCompleted;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: SizedBox(
        height: 64,
        child: Stack(
          children: [
            // Hidden input that actually receives the keyboard.
            Opacity(
              opacity: 0,
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                autofocus: true,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(length),
                ],
                onChanged: (v) {
                  onChanged();
                  if (v.length == length) onCompleted(v);
                },
              ),
            ),
            Positioned.fill(
              child: GestureDetector(
                onTap: () => focusNode.requestFocus(),
                child: ListenableBuilder(
                  listenable: Listenable.merge([controller, focusNode]),
                  builder: (context, _) {
                    final text = controller.text;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 0; i < length; i++)
                          Container(
                            width: 64,
                            height: 64,
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                width: 2,
                                color: hasError
                                    ? AppColors.error
                                    : focusNode.hasFocus && i == text.length
                                        ? AppColors.primary
                                        : AppColors.border,
                              ),
                            ),
                            child: Text(
                              i < text.length ? text[i] : '',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(fontSize: 28),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
