part of 'search_widgets_imports.dart';

/// Search field (with clear button) + filters button.
class SearchBarRow extends StatelessWidget {
  const SearchBarRow({
    super.key,
    required this.query,
    required this.onChanged,
    required this.onClear,
    required this.onFilters,
  });

  final TextEditingController query;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final VoidCallback onFilters;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: query,
              builder: (context, value, _) => TextField(
                controller: query,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: S.searchHint,
                  prefixIcon: const Icon(AppIcons.search),
                  suffixIcon: value.text.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(AppIcons.close),
                          onPressed: onClear,
                        ),
                ),
                onChanged: onChanged,
              ),
            ),
          ),
          const SizedBox(width: 10),
          SquareIconButton(icon: AppIcons.filter, onPressed: onFilters),
        ],
      ),
    );
  }
}
