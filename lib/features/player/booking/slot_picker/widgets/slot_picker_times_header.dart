part of 'slot_picker_widgets_imports.dart';

/// "Available times" + legend.
class SlotPickerTimesHeader extends StatelessWidget {
  const SlotPickerTimesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
      child: Row(
        children: [
          Expanded(
            child: Text(S.availableTimes,
                style: Theme.of(context).textTheme.titleMedium),
          ),
          const SlotLegend(
              states: [SlotState.available, SlotState.blocked],
              playerView: true),
        ],
      ),
    );
  }
}
