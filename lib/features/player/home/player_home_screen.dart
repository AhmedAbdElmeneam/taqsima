part of 'player_home_imports.dart';

class PlayerHomeScreen extends ConsumerStatefulWidget {
  const PlayerHomeScreen({super.key});

  @override
  ConsumerState<PlayerHomeScreen> createState() => _PlayerHomeScreenState();
}

class _PlayerHomeScreenState extends ConsumerState<PlayerHomeScreen> {
  late final PlayerHomeController controller = PlayerHomeController(ref);

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(sessionProvider);
    final next = ref.watch(nextMatchProvider).valueOrNull;
    final pitches = ref.watch(nearbyPitchesProvider);
    final availableToday = ref.watch(availableTodayProvider).valueOrNull;
    final bookAgain = ref.watch(bookAgainProvider).valueOrNull;

    return TabPage(
      child: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: controller.refresh,
        child: ListView(
          padding:
              const EdgeInsets.fromLTRB(20, 8, 20, AppSpacing.navBarClearance),
          children: [
            PlayerHeroHeader(
              firstName: (user?.name ?? '').split(' ').first,
              next: next,
              onFindMatch: () => controller.openSearchTab(context),
              onOpenBooking: (b) => controller.openBooking(context, b),
            ),
            const SizedBox(height: 14),
            HomeSearchBar(
              onSubmitted: (q) => controller.searchText(context, q),
              onFilters: () => controller.openFilters(context),
            ),
            const SizedBox(height: 22),
            if (availableToday != null && availableToday.isNotEmpty)
              AvailableTodayStrip(
                items: availableToday,
                onTap: (pitch, slot) =>
                    controller.openSlot(context, pitch, slot),
              ),
            if (bookAgain != null && bookAgain.isNotEmpty)
              BookAgainRow(
                pitches: bookAgain,
                onTap: (p) => controller.bookAgain(context, p),
              ),
            SectionHeader(
              title: S.nearbyPitches,
              action: S.seeAll,
              onAction: () => controller.seeAllPitches(context),
            ),
            const SizedBox(height: 8),
            AsyncView(
              value: pitches,
              builder: (list) => NearbyPitchesList(
                pitches: list,
                distanceOf: controller.distanceTo,
                onTap: (p) => controller.openPitch(context, p),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
