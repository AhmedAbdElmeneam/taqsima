part of 'slot_picker_widgets_imports.dart';

class SlotPickerSectionTitle extends StatelessWidget {
  const SlotPickerSectionTitle(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: Text(text, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
