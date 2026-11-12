part of 'search_widgets_imports.dart';

/// Empty state, map view or list of pitch cards.
class SearchResults extends StatelessWidget {
  const SearchResults({
    super.key,
    required this.pitches,
    required this.mapView,
    required this.onReset,
    required this.onOpen,
  });

  final List<Pitch> pitches;
  final bool mapView;
  final VoidCallback onReset;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    if (pitches.isEmpty) {
      return EmptyState(
        icon: AppIcons.notFound,
        title: S.noResults,
        message: S.noResultsHint,
        actionLabel: S.resetFilters,
        onAction: onReset,
      );
    }
    if (mapView) return SearchMapView(pitches: pitches, onOpen: onOpen);

    return ListView.separated(
      padding:
          const EdgeInsets.fromLTRB(20, 0, 20, AppSpacing.navBarClearance),
      itemCount: pitches.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (_, i) => FadeSlideIn(
        index: i,
        child: PitchCard(
          pitch: pitches[i],
          onTap: () => onOpen(pitches[i].id),
        ),
      ),
    );
  }
}
