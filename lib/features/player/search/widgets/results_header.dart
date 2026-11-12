part of 'search_widgets_imports.dart';

/// Results count + list/map toggle.
class ResultsHeader extends StatelessWidget {
  const ResultsHeader({
    super.key,
    required this.count,
    required this.mapView,
    required this.onViewChanged,
  });

  final int count;
  final bool mapView;
  final ValueChanged<bool> onViewChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(S.resultsCount(count),
                style: Theme.of(context).textTheme.titleMedium),
          ),
          SegmentedButton<bool>(
            showSelectedIcon: false,
            style: SegmentedButton.styleFrom(
              selectedBackgroundColor: AppColors.primaryLight,
              selectedForegroundColor: AppColors.primaryDark,
              visualDensity: VisualDensity.standard,
            ),
            segments: const [
              ButtonSegment(
                  value: false,
                  icon: Icon(AppIcons.list),
                  label: Text(S.listView)),
              ButtonSegment(
                  value: true,
                  icon: Icon(AppIcons.map),
                  label: Text(S.mapView)),
            ],
            selected: {mapView},
            onSelectionChanged: (s) => onViewChanged(s.first),
          ),
        ],
      ),
    );
  }
}
