part of 'pitch_details_widgets_imports.dart';

/// Bottom bar: starting price + book button.
class PitchBookBar extends StatelessWidget {
  const PitchBookBar(
      {super.key, required this.pricePerHour, required this.onBook});

  final int pricePerHour;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return BottomActionBar(
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(S.startingFrom, style: t.bodySmall),
              Text(S.pricePerHour(pricePerHour),
                  style: t.titleMedium?.copyWith(color: AppColors.primary)),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: PrimaryButton(
              label: S.book,
              icon: AppIcons.calendarCheck,
              onPressed: onBook,
            ),
          ),
        ],
      ),
    );
  }
}
