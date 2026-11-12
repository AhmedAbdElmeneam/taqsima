part of 'my_bookings_widgets_imports.dart';

/// One tab's list of booking cards, or [empty] when there are none.
class BookingsList extends StatelessWidget {
  const BookingsList({
    super.key,
    required this.bookings,
    required this.empty,
    required this.onTap,
  });

  final List<Booking> bookings;
  final Widget empty;
  final ValueChanged<Booking> onTap;

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) return empty;
    return ListView.separated(
      padding:
          const EdgeInsets.fromLTRB(20, 16, 20, AppSpacing.navBarClearance),
      itemCount: bookings.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => FadeSlideIn(
        index: i,
        child: PlayerBookingCard(
          booking: bookings[i],
          onTap: () => onTap(bookings[i]),
        ),
      ),
    );
  }
}
