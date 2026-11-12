part of 'filter_widgets_imports.dart';

/// One selectable chip inside a [FilterSection].
class FilterChoice extends StatelessWidget {
  const FilterChoice({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      showCheckmark: false,
      onSelected: (_) => onTap(),
      labelStyle: TextStyle(
        color: selected ? AppColors.primaryDark : AppColors.ink,
        fontWeight: FontWeight.w700,
      ),
      side: BorderSide(
          color: selected ? AppColors.primary : AppColors.border, width: 1.5),
    );
  }
}
