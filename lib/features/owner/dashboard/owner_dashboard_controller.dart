part of 'owner_dashboard_imports.dart';

/// Today's figures and navigation for the owner home.
class OwnerDashboardController {
  OwnerDashboardController(this.ref);
  final WidgetRef ref;

  Future<void> refresh() async => ref.refreshData();

  /// Confirmed / manual bookings (pending requests are not counted).
  int bookedCount(List<TimeSlot> slots) => slots
      .where((s) =>
          s.booking != null && s.booking!.status != BookingStatus.pending)
      .length;

  int freeCount(List<TimeSlot> slots) =>
      slots.where((s) => s.isBookable).length;

  int revenue(List<TimeSlot> slots) => revenueOf(slots);

  void addPitch(BuildContext context) => context.push(Routes.ownerPitchForm);

  void openRequests(BuildContext context) => context.go(Routes.ownerRequests);

  void openCalendar(BuildContext context) => context.go(Routes.ownerCalendar);

  void tapSlot(BuildContext context, TimeSlot slot) =>
      onOwnerSlotTap(context, slot);
}
