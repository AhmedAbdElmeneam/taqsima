part of 'otp_widgets_imports.dart';

/// Four visual boxes driven by one hidden text field (LTR digits),
/// with the error message under them.
class OtpCodeInput extends StatelessWidget {
  const OtpCodeInput({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.length,
    required this.error,
    required this.onChanged,
    required this.onCompleted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final int length;
  final ValueNotifier<String?> error;
  final VoidCallback onChanged;
  final VoidCallback onCompleted;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: error,
      builder: (context, message, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Directionality(
            textDirection: TextDirection.ltr,
            child: SizedBox(
              height: 56,
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
                        if (v.length == length) onCompleted();
                      },
                    ),
                  ),
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: focusNode.requestFocus,
                      child: ListenableBuilder(
                        listenable: Listenable.merge([controller, focusNode]),
                        builder: (context, _) {
                          final text = controller.text;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (var i = 0; i < length; i++)
                                OtpBox(
                                  digit: i < text.length ? text[i] : '',
                                  active:
                                      focusNode.hasFocus && i == text.length,
                                  hasError: message != null,
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
          ),
          const SizedBox(height: 12),
          if (message != null)
            Text(message,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.error)),
        ],
      ),
    );
  }
}
