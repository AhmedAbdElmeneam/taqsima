part of 'player_home_imports.dart';

/// Navigation and data actions for the player home tab.
class PlayerHomeController {
  PlayerHomeController(this.ref);
  final WidgetRef ref;

  Future<void> refresh() async => ref.refreshData();

  /// Applies [filter] and jumps to the search tab.
  void searchWith(BuildContext context, PitchFilter filter) {
    ref.read(searchFilterProvider.notifier).state = filter;
    context.go(Routes.playerSearch);
  }

  void searchText(BuildContext context, String query) => searchWith(
      context, ref.read(searchFilterProvider).copyWith(query: () => query));

  void seeAllPitches(BuildContext context) =>
      searchWith(context, const PitchFilter());

  Future<void> openFilters(BuildContext context) async {
    if (await showFilterSheet(context) && context.mounted) {
      context.go(Routes.playerSearch);
    }
  }

  void openSearchTab(BuildContext context) => context.go(Routes.playerSearch);

  void openPitch(BuildContext context, Pitch pitch) =>
      context.push(Routes.pitch(pitch.id));

  void openBooking(BuildContext context, Booking booking) =>
      context.push(Routes.playerBooking(booking.id));

  /// Opens the slot picker on the day of [slot].
  void openSlot(BuildContext context, Pitch pitch, TimeSlot slot) {
    ref.read(selectedDateProvider.notifier).state = Fmt.dateOnly(slot.startAt);
    context.push(Routes.pitchSlots(pitch.id));
  }

  void bookAgain(BuildContext context, Pitch pitch) =>
      context.push(Routes.pitchSlots(pitch.id));

  double distanceTo(Pitch p) =>
      distanceKm(playerLocation.lat, playerLocation.lng, p.lat, p.lng);
}
