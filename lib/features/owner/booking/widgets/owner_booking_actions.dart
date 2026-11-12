part of 'owner_booking_details_widgets_imports.dart';

/// Call (confirmed only) or accept / reject (pending only).
class OwnerBookingActions extends StatelessWidget {
  const OwnerBookingActions({
    super.key,
    required this.canCall,
    required this.pending,
    required this.onCall,
    required this.onAnswer,
  });

  final bool canCall;
  final bool pending;
  final VoidCallback onCall;
  final ValueChanged<bool> onAnswer;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (canCall)
          PrimaryButton(label: S.call, icon: AppIcons.call, onPressed: onCall),
        if (pending) ...[
          PrimaryButton(
            label: S.accept,
            icon: AppIcons.check,
            onPressed: () => onAnswer(true),
          ),
          const SizedBox(height: 10),
          SecondaryButton(
            label: S.reject,
            icon: AppIcons.close,
            color: AppColors.error,
            onPressed: () => onAnswer(false),
          ),
        ],
      ],
    );
  }
}
