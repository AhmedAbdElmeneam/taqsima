part of 'booking_confirm_widgets_imports.dart';

/// "The owner confirms your request" note.
class RequestNote extends StatelessWidget {
  const RequestNote({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(AppIcons.info, size: 20, color: AppColors.inkMuted),
        const SizedBox(width: 8),
        Expanded(
          child: Text(S.requestNote,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.inkMuted)),
        ),
      ],
    );
  }
}
