part of 'owner_dashboard_imports.dart';

class OwnerDashboardScreen extends ConsumerStatefulWidget {
  const OwnerDashboardScreen({super.key});

  @override
  ConsumerState<OwnerDashboardScreen> createState() =>
      _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState extends ConsumerState<OwnerDashboardScreen> {
  late final OwnerDashboardController controller =
      OwnerDashboardController(ref);

  @override
  Widget build(BuildContext context) {
    final pitch = ref.watch(currentOwnerPitchProvider);
    return TabPage(
      child: AsyncView(
        value: pitch,
        builder: (p) => p == null
            ? EmptyState(
                icon: AppIcons.pitch,
                title: S.noPitchYet,
                message: S.noPitchYetHint,
                actionLabel: S.addPitch,
                onAction: () => controller.addPitch(context),
              )
            // Consumer: these providers are watched by this subtree's own build.
            : Consumer(builder: (context, ref, _) => _dashboard(ref, p)),
      ),
    );
  }

  Widget _dashboard(WidgetRef ref, Pitch pitch) {
    final slots = ref.watch(daySlotsProvider((pitch.id, todayDate())));
    final requests = ref.watch(ownerRequestsProvider).valueOrNull ?? const [];

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: controller.refresh,
      child: ListView(
        padding:
            const EdgeInsets.fromLTRB(20, 8, 20, AppSpacing.navBarClearance),
        children: [
          MatchdayHeader(pitch: pitch, slots: slots.valueOrNull),
          const SizedBox(height: 14),
          if (pitch.status == PitchStatus.pending) ...[
            const UnderReviewBanner(),
            const SizedBox(height: 14),
          ],
          if (requests.isNotEmpty) ...[
            PendingRequestsBanner(
              count: requests.length,
              onTap: () => controller.openRequests(context),
            ),
            const SizedBox(height: 14),
          ],
          AsyncView(
            value: slots,
            builder: (list) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DashboardStats(
                  revenue: controller.revenue(list),
                  booked: controller.bookedCount(list),
                  free: controller.freeCount(list),
                ),
                const SizedBox(height: 12),
                OccupancyMeter(slots: list),
                const SizedBox(height: 22),
                TodayTimeline(
                  slots: list,
                  onOpenCalendar: () => controller.openCalendar(context),
                  onSlotTap: (s) => controller.tapSlot(context, s),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
