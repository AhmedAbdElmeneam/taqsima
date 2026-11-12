part of 'search_imports.dart';

/// Search text, view mode and filter edits for the search tab.
class PitchSearchController {
  PitchSearchController(this.ref)
      : query = TextEditingController(text: ref.read(searchFilterProvider).query);

  final WidgetRef ref;
  final TextEditingController query;
  final mapView = ValueNotifier(false);

  PitchFilter get _filter => ref.read(searchFilterProvider);

  void _update(PitchFilter f) =>
      ref.read(searchFilterProvider.notifier).state = f;

  /// Keeps the field in sync when the filter changes from elsewhere (home).
  void syncQuery(PitchFilter next) {
    if ((next.query ?? '') != query.text) query.text = next.query ?? '';
  }

  void onQueryChanged(String q) => _update(_filter.copyWith(query: () => q));

  void clearQuery() {
    query.clear();
    _update(_filter.copyWith(query: () => null));
  }

  void clearArea() => _update(_filter.copyWith(area: () => null));
  void clearType() => _update(_filter.copyWith(type: () => null));
  void clearMaxPrice() => _update(_filter.copyWith(maxPrice: () => null));

  void resetAll() {
    query.clear();
    _update(const PitchFilter());
  }

  void openFilters(BuildContext context) => showFilterSheet(context);

  void openPitch(BuildContext context, String pitchId) =>
      context.push(Routes.pitch(pitchId));

  void dispose() {
    query.dispose();
    mapView.dispose();
  }
}
