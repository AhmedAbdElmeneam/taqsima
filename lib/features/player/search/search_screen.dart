part of 'search_imports.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final PitchSearchController controller = PitchSearchController(ref);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(searchFilterProvider);
    final results = ref.watch(searchResultsProvider);
    ref.listen(searchFilterProvider, (_, next) => controller.syncQuery(next));

    return TabPage(
      child: Column(
        children: [
          const PageTitle(S.searchResults),
          SearchBarRow(
            query: controller.query,
            onChanged: controller.onQueryChanged,
            onClear: controller.clearQuery,
            onFilters: () => controller.openFilters(context),
          ),
          ActiveFilterChips(
            chips: [
              if (filter.area != null)
                (filter.area!, controller.clearArea),
              if (filter.type != null)
                (filter.type!.label, controller.clearType),
              if (filter.maxPrice != null)
                ('≤ ${S.price(filter.maxPrice!)}', controller.clearMaxPrice),
            ],
          ),
          ValueListenableBuilder<bool>(
            valueListenable: controller.mapView,
            builder: (context, mapView, _) => Expanded(
              child: Column(
                children: [
                  ResultsHeader(
                    count: results.valueOrNull?.length ?? 0,
                    mapView: mapView,
                    onViewChanged: (v) => controller.mapView.value = v,
                  ),
                  Expanded(
                    child: AsyncView(
                      value: results,
                      builder: (list) => SearchResults(
                        pitches: list,
                        mapView: mapView,
                        onReset: controller.resetAll,
                        onOpen: (id) => controller.openPitch(context, id),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
