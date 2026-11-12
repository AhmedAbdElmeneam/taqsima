part of 'weekly_calendar_imports.dart';

/// Week grid: columns = days, rows = slot start times, every cell color-coded.
class WeeklyCalendarScreen extends ConsumerStatefulWidget {
  const WeeklyCalendarScreen({super.key});

  @override
  ConsumerState<WeeklyCalendarScreen> createState() =>
      _WeeklyCalendarScreenState();
}

class _WeeklyCalendarScreenState extends ConsumerState<WeeklyCalendarScreen> {
  final controller = WeeklyCalendarController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pitch = ref.watch(currentOwnerPitchProvider);

    return TabPage(
      child: AsyncView(
        value: pitch,
        builder: (p) {
          if (p == null) {
            return const EmptyState(icon: AppIcons.pitch, title: S.noPitchYet);
          }
          return ListenableBuilder(
            listenable:
                Listenable.merge([controller.weekOffset, controller.filter]),
            // Consumer so only the shown week stays subscribed when paging.
            builder: (context, _) => Consumer(builder: (context, ref, _) {
              final start = controller.weekStart;
              final week = ref.watch(weekSlotsProvider((p.id, start)));
              // One vertical scroll for the whole screen.
              return ListView(
                padding:
                    const EdgeInsets.only(bottom: AppSpacing.navBarClearance),
                children: [
                  const PageTitle(S.weeklyCalendar,
                      padding: EdgeInsets.fromLTRB(20, 12, 20, 0)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: PitchSwitcher(pitch: p),
                  ),
                  WeekNavigator(
                    start: start,
                    end: controller.weekEnd,
                    onPrevious:
                        controller.canGoBack ? controller.previousWeek : null,
                    onNext:
                        controller.canGoForward ? controller.nextWeek : null,
                  ),
                  AsyncView(
                    value: week,
                    builder: (days) => Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CalendarFilterBar(
                          days: days,
                          selected: controller.filter.value,
                          onSelected: controller.toggleFilter,
                        ),
                        WeekGrid(
                          days: days,
                          start: start,
                          filter: controller.filter.value,
                          onSlotTap: (s) => controller.tapSlot(context, s),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          );
        },
      ),
    );
  }
}
