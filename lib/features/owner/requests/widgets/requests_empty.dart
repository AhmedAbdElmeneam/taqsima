part of 'booking_requests_widgets_imports.dart';

/// No requests at all, or no match for the search.
class RequestsEmpty extends StatelessWidget {
  const RequestsEmpty({super.key, required this.searching});
  final bool searching;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: searching
          ? const EmptyState(
              icon: AppIcons.notFound,
              title: S.noSearchResults,
              message: S.noSearchResultsHint,
            )
          : const EmptyState(
              icon: AppIcons.inbox,
              title: S.noRequests,
              message: S.noRequestsHint,
            ),
    );
  }
}
