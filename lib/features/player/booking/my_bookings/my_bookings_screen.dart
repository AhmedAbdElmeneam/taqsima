part of 'my_bookings_imports.dart';

class MyBookingsScreen extends ConsumerWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = MyBookingsController();
    final bookings = ref.watch(myBookingsProvider);

    return DefaultTabController(
      length: 2,
      child: TabPage(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const PageTitle(S.navMyBookings),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: TabBar(tabs: [Tab(text: S.upcoming), Tab(text: S.past)]),
            ),
            Expanded(
              child: AsyncView(
                value: bookings,
                builder: (all) {
                  final (upcoming, past) = controller.split(all);
                  void open(Booking b) => controller.openBooking(context, b);
                  return TabBarView(
                    children: [
                      BookingsList(
                        bookings: upcoming,
                        onTap: open,
                        empty: EmptyState(
                          icon: AppIcons.ball,
                          title: S.noUpcoming,
                          message: S.noUpcomingHint,
                          actionLabel: S.findPitch,
                          onAction: () => controller.findPitch(context),
                        ),
                      ),
                      BookingsList(
                        bookings: past,
                        onTap: open,
                        empty: const EmptyState(
                            icon: AppIcons.history, title: S.noPast),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
