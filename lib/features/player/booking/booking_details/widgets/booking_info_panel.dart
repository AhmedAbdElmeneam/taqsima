part of 'player_booking_details_widgets_imports.dart';

/// Booking number, date, time and total.
class BookingInfoPanel extends StatelessWidget {
  const BookingInfoPanel({super.key, required this.booking});
  final Booking booking;

  @override
  Widget build(BuildContext context) {
    final b = booking;
    return AppPanel(
      child: Column(
        children: [
          InfoRow(
              icon: AppIcons.ticket,
              label: S.bookingNumber,
              value: Fmt.ltr('#${b.id.toUpperCase()}')),
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
