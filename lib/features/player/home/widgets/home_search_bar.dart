part of 'player_home_widgets_imports.dart';

/// Search field + filters button on the player home.
class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar(
      {super.key, required this.onSubmitted, required this.onFilters});

  final ValueChanged<String> onSubmitted;
  final VoidCallback onFilters;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            textInputAction: TextInputAction.search,
            decoration: const InputDecoration(
              hintText: S.searchHint,
              prefixIcon: Icon(AppIcons.search),
            ),
            onSubmitted: onSubmitted,
          ),
        ),
        const SizedBox(width: 10),
        SquareIconButton(icon: AppIcons.filter, onPressed: onFilters),
      ],
    );
  }
}
