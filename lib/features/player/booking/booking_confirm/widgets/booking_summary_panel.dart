part of 'booking_confirm_widgets_imports.dart';

/// Pitch, date, time, duration and total.
class BookingSummaryPanel extends StatelessWidget {
  const BookingSummaryPanel(
      {super.key, required this.slot, required this.pitch});

  final TimeSlot slot;
  final Pitch? pitch;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final p = pitch;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(S.bookingSummary, style: t.titleLarge),
        const SizedBox(height: 8),
        AppPanel(
          child: Column(
            children: [
              if (p != null)
                InfoRow(
                    icon: AppIcons.location,
                    label: S.pitch,
                    value: '${p.name} - ${p.area}'),
              InfoRow(
                  icon: AppIcons.calendar,
                  label: S.date,
                  value: Fmt.dayRelative(slot.startAt)),
              InfoRow(
                  icon: AppIcons.clock,
                  label: S.time,
                  value: Fmt.timeRange(slot.startAt, slot.endAt)),
              InfoRow(
                  icon: AppIcons.duration,
                  label: S.duration,
                  value: Fmt.duration(slot.duration)),
              const Divider(height: 24),
              InfoRow(
                  icon: AppIcons.money,
                  label: S.total,
                  value: S.price(slot.price),
                  valueColor: AppColors.primary),
              Text(S.paymentAtPitch,
                  style: t.bodySmall, textAlign: TextAlign.center),
            ],
          ),
        ),
      ],
    );
  }
}
