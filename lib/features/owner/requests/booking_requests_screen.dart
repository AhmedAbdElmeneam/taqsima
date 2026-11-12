part of 'booking_requests_imports.dart';

class BookingRequestsScreen extends ConsumerStatefulWidget {
  const BookingRequestsScreen({super.key});

  @override
  ConsumerState<BookingRequestsScreen> createState() =>
      _BookingRequestsScreenState();
}

class _BookingRequestsScreenState extends ConsumerState<BookingRequestsScreen> {
  late final BookingRequestsController controller =
      BookingRequestsController(ref);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final all = ref.watch(ownerRequestsProvider).valueOrNull ?? const [];
    final list = ref.watch(filteredRequestsProvider).valueOrNull;
    final searching = ref.watch(requestSearchProvider).trim().isNotEmpty;

    // Whole screen scrolls: title, search box and cards in one list.
    return TabPage(
      child: ListView(
        padding: const EdgeInsets.only(bottom: AppSpacing.navBarClearance),
        children: [
          const PageTitle(S.bookingRequests),
          // Only show the search box when there is something to search.
          if (all.isNotEmpty || searching)
            RequestsSearchField(
              controller: controller.search,
              searching: searching,
              onChanged: controller.onSearchChanged,
              onClear: controller.clearSearch,
            ),
          if (list == null)
            const Padding(
              padding: EdgeInsets.only(top: 80),
              child: Center(child: BallLoader()),
            )
          else if (list.isEmpty)
            RequestsEmpty(searching: searching)
          else
            for (final (i, b) in list.indexed)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                child: FadeSlideIn(
                  index: i,
                  child: RequestCard(
                    key: ValueKey(b.id),
                    booking: b,
                    onTap: () => controller.openBooking(context, b),
                    onAnswer: (accept) =>
                        controller.answer(context, b, accept: accept),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
