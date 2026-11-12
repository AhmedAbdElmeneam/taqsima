part of 'slot_picker_imports.dart';

/// THE key screen: pick a day on top, then tap one free slot.
class SlotPickerScreen extends ConsumerStatefulWidget {
  const SlotPickerScreen({super.key, required this.pitchId});
  final String pitchId;

  @override
  ConsumerState<SlotPickerScreen> createState() => _SlotPickerScreenState();
}

class _SlotPickerScreenState extends ConsumerState<SlotPickerScreen> {
  late final SlotPickerController controller =
      SlotPickerController(ref, widget.pitchId);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pitch = ref.watch(pitchProvider(widget.pitchId)).valueOrNull;

    return ListenableBuilder(
      listenable: Listenable.merge([controller.day, controller.selected]),
      // Consumer so the day's provider is watched by this builder only and
      // the previous day's subscription is dropped when the day changes.
      builder: (context, _) => Consumer(builder: (context, ref, _) {
        final day = controller.day.value;
        final slots = ref.watch(daySlotsProvider((widget.pitchId, day)));
        final selected = controller.validSelection(slots.valueOrNull);

        return Scaffold(
          appBar: AppBar(title: const Text(S.chooseTime)),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (pitch != null) SlotPickerPitchHeader(pitch: pitch),
              const SlotPickerSectionTitle(S.chooseDay),
              DaySelector(selected: day, onSelected: controller.selectDay),
              const SlotPickerTimesHeader(),
              Expanded(
                child: AsyncView(
                  value: slots,
                  builder: (list) => SlotGrid(
                    day: day,
                    slots: list,
                    selected: selected,
                    onSelect: controller.selectSlot,
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: SlotPickerBottomBar(
            selected: selected,
            onContinue: selected == null
                ? null
                : () => controller.continueTo(context, selected),
          ),
        );
      }),
    );
  }
}
