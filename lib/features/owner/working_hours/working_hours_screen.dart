part of 'working_hours_imports.dart';

/// Per-weekday opening hours + one slot duration for the pitch.
class WorkingHoursScreen extends ConsumerWidget {
  const WorkingHoursScreen({super.key, required this.pitchId});
  final String pitchId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(workingHoursProvider(pitchId)).when(
          skipLoadingOnReload: true,
          data: (h) => _Editor(pitchId: pitchId, initial: h),
          loading: () => const Scaffold(body: Center(child: BallLoader())),
          error: (_, __) => const Scaffold(
              body:
                  EmptyState(icon: AppIcons.warning, title: S.somethingWrong)),
        );
  }
}

class _Editor extends ConsumerStatefulWidget {
  const _Editor({required this.pitchId, required this.initial});
  final String pitchId;
  final List<WorkingHours> initial;

  @override
  ConsumerState<_Editor> createState() => _EditorState();
}

class _EditorState extends ConsumerState<_Editor> {
  late final WorkingHoursController controller =
      WorkingHoursController(ref, widget.pitchId, widget.initial);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller.changes,
      builder: (context, _) {
        final days = controller.days.value;
        return Scaffold(
          appBar: AppBar(title: const Text(S.workingHours)),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              SlotDurationPicker(
                options: WorkingHoursController.durations,
                selected: controller.duration.value,
                onChanged: controller.setDuration,
              ),
              const SizedBox(height: 20),
              for (final d in WorkingHoursController.order) ...[
                DayHoursRow(
                  name: S.weekdays[d],
                  day: days[d]!,
                  onToggle: (v) => controller.setOpen(d, v),
                  onFrom: () =>
                      controller.pickTime(context, d, isFrom: true),
                  onTo: () => controller.pickTime(context, d, isFrom: false),
                ),
                const SizedBox(height: 10),
              ],
            ],
          ),
          bottomNavigationBar: BottomActionBar(
            child: PrimaryButton(
              label: S.save,
              loading: controller.saving.value,
              onPressed: () => controller.save(context),
            ),
          ),
        );
      },
    );
  }
}
