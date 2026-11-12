part of 'owner_booking_details_widgets_imports.dart';

/// Pitch, date, time and total.
class BookingTimePanel extends StatelessWidget {
  const BookingTimePanel(
      {super.key, required this.booking, required this.pitch});

  final Booking booking;
  final Pitch? pitch;

  @override
  Widget build(BuildContext context) {
    final b = booking;
    final p = pitch;
    return AppPanel(
      child: Column(
        children: [
          if (p != null)
            InfoRow(icon: AppIcons.pitch, label: S.pitch, value: p.name),
          InfoRow(
              icon: AppIcons.calendar,
              label: S.date,
              value: Fmt.dayLong(b.startAt)),
          InfoRow(
              icon: AppIcons.clock,
              label: S.time,
              value: Fmt.timeRange(b.startAt, b.endAt)),
          InfoRow(
              icon: AppIcons.money,
              label: S.total,
              value: S.price(b.price),
              valueColor: AppColors.primary),
        ],
      ),
    );
  }
}
