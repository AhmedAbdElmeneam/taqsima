part of 'booking_requests_widgets_imports.dart';

/// Accept / reject buttons with a busy state while the answer is sent.
class RequestActions extends StatefulWidget {
  const RequestActions({super.key, required this.onAnswer, this.compact = true});

  final Future<void> Function(bool accept) onAnswer;
  final bool compact;

  @override
  State<RequestActions> createState() => _RequestActionsState();
}

class _RequestActionsState extends State<RequestActions> {
  final _busy = ValueNotifier(false);

  @override
  void dispose() {
    _busy.dispose();
    super.dispose();
  }

  Future<void> _answer(bool accept) async {
    _busy.value = true;
    try {
      await widget.onAnswer(accept);
    } finally {
      if (mounted) _busy.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _busy,
      builder: (context, busy, _) => Row(
        children: [
          Expanded(
            child: PrimaryButton(
              label: S.accept,
              compact: widget.compact,
              icon: AppIcons.check,
              loading: busy,
              onPressed: () => _answer(true),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: SecondaryButton(
              label: S.reject,
              compact: widget.compact,
              icon: AppIcons.close,
              color: AppColors.error,
              onPressed: busy ? null : () => _answer(false),
            ),
          ),
        ],
      ),
    );
  }
}
