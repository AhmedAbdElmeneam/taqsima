import 'package:flutter/material.dart';
import 'package:ma3adna/core/theme/app_spacing.dart';
import 'package:ma3adna/core/theme/app_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_strings.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/labels.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/repositories/repositories.dart';
import '../player_providers.dart';
import 'filter_sheet.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final _query =
      TextEditingController(text: ref.read(searchFilterProvider).query);
  bool _mapView = false;

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  void _update(PitchFilter f) =>
      ref.read(searchFilterProvider.notifier).state = f;

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(searchFilterProvider);
    final results = ref.watch(searchResultsProvider);
    final t = Theme.of(context).textTheme;

    // Keep the field in sync when the filter is changed from home.
    ref.listen(searchFilterProvider, (_, next) {
      if ((next.query ?? '') != _query.text) _query.text = next.query ?? '';
    });

    final activeChips = <Widget>[
      if (filter.area != null)
        _ActiveChip(
            filter.area!, () => _update(filter.copyWith(area: () => null))),
      if (filter.type != null)
        _ActiveChip(filter.type!.label,
            () => _update(filter.copyWith(type: () => null))),
      if (filter.maxPrice != null)
        _ActiveChip('≤ ${S.price(filter.maxPrice!)}',
            () => _update(filter.copyWith(maxPrice: () => null))),
    ];

    return TabPage(
      child: Column(
        children: [
          const PageTitle(S.searchResults),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _query,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: S.searchHint,
                      prefixIcon: const Icon(AppIcons.search),
                      suffixIcon: _query.text.isEmpty
                          ? null
                          : IconButton(
                              icon: const Icon(AppIcons.close),
                              onPressed: () {
                                _query.clear();
                                _update(filter.copyWith(query: () => null));
                              },
                            ),
                    ),
                    onChanged: (q) => _update(ref
                        .read(searchFilterProvider)
                        .copyWith(query: () => q)),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton.filled(
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    fixedSize: const Size(56, 56),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: const Icon(AppIcons.filter),
                  onPressed: () => showFilterSheet(context),
                ),
              ],
            ),
          ),
          if (activeChips.isNotEmpty)
            SizedBox(
              height: 52,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                children: activeChips,
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    S.resultsCount(results.valueOrNull?.length ?? 0),
                    style: t.titleMedium,
                  ),
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
                  selected: {_mapView},
                  onSelectionChanged: (s) => setState(() => _mapView = s.first),
                ),
              ],
            ),
          ),
          Expanded(
            child: AsyncView(
              value: results,
              builder: (list) {
                if (list.isEmpty) {
                  return EmptyState(
                    icon: AppIcons.notFound,
                    title: S.noResults,
                    message: S.noResultsHint,
                    actionLabel: S.resetFilters,
                    onAction: () {
                      _query.clear();
                      _update(const PitchFilter());
                    },
                  );
                }
                if (_mapView) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(
                        20, 0, 20, AppSpacing.navBarClearance),
                    child: Column(
                      children: [
                        Expanded(
                          child: MapPlaceholder(
                            pins: [
                              for (final p in list)
                                MapPin(
                                    id: p.id,
                                    lat: p.lat,
                                    lng: p.lng,
                                    label: p.name),
                            ],
                            onPinTap: (pin) =>
                                context.push(Routes.pitch(pin.id)),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(S.mapPlaceholderNote, style: t.bodySmall),
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                      20, 0, 20, AppSpacing.navBarClearance),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (_, i) => FadeSlideIn(
                    index: i,
                    child: PitchCard(
                      pitch: list[i],
                      onTap: () => context.push(Routes.pitch(list[i].id)),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ActiveChip extends StatelessWidget {
  const _ActiveChip(this.label, this.onRemove);
  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsetsDirectional.only(end: 8),
        child: InputChip(
          label: Text(label),
          selected: true,
          showCheckmark: false,
          onDeleted: onRemove,
          deleteIcon: const Icon(AppIcons.close, size: 18),
          side: BorderSide(color: AppColors.primary),
        ),
      );
}
