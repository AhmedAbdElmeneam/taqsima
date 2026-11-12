part of 'search_widgets_imports.dart';

/// Removable chips for the filters currently applied.
class ActiveFilterChips extends StatelessWidget {
  const ActiveFilterChips({super.key, required this.chips});

  /// (label, onRemove) pairs.
  final List<(String, VoidCallback)> chips;

  @override
  Widget build(BuildContext context) {
    if (chips.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 52,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
        children: [
          for (final (label, onRemove) in chips)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 8),
              child: InputChip(
                label: Text(label),
                selected: true,
                showCheckmark: false,
                onDeleted: onRemove,
                deleteIcon: const Icon(AppIcons.close, size: 18),
                side: BorderSide(color: AppColors.primary),
              ),
            ),
        ],
      ),
    );
  }
}
