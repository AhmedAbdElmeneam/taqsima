part of 'booking_success_widgets_imports.dart';

/// Pitch name, day/time and status of the new booking.
class SuccessBookingPanel extends StatelessWidget {
  const SuccessBookingPanel(
      {super.key, required this.booking, required this.pitch});

  final Booking booking;
  final Pitch pitch;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return AppPanel(
      child: Column(
        children: [
          Text(pitch.name, style: t.titleLarge),
          const SizedBox(height: 4),
          Text(
            '${Fmt.dayRelative(booking.startAt)} • ${Fmt.timeRange(booking.startAt, booking.endAt)}',
            style: t.bodyLarge,
          ),
          const SizedBox(height: 10),
          BookingStatusBadge(status: booking.status),
        ],
      ),
    );
  }
}
