part of 'filter_imports.dart';

/// Opens the filters sheet. Returns true when the player applied filters.
Future<bool> showFilterSheet(BuildContext context) async {
  final applied = await showAppBottomSheet<bool>(
    context,
    title: S.filters,
    builder: (_) => const FilterSheet(),
  );
  return applied ?? false;
}

class FilterSheet extends ConsumerStatefulWidget {
  const FilterSheet({super.key});

  @override
  ConsumerState<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends ConsumerState<FilterSheet> {
  late final FilterController controller = FilterController(ref);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final areas = ref.watch(areasProvider).valueOrNull ?? const <String>[];

    return ListenableBuilder(
      listenable: Listenable.merge([controller.filter, controller.date]),
      builder: (context, _) {
        final filter = controller.filter.value;
        final date = controller.date.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilterSection(title: S.date, children: [
              for (final d in controller.days)
                FilterChoice(
                  label: Fmt.dayRelative(d),
                  selected: Fmt.isSameDay(date, d),
                  onTap: () => controller.setDate(d),
                ),
            ]),
            FilterSection(title: S.area, children: [
              FilterChoice(
                label: S.anyArea,
                selected: filter.area == null,
                onTap: () => controller.setArea(null),
              ),
              for (final a in areas)
                FilterChoice(
                  label: a,
                  selected: filter.area == a,
                  onTap: () => controller.setArea(a),
                ),
            ]),
            FilterSection(title: S.pitchType, children: [
              FilterChoice(
                label: S.anyType,
                selected: filter.type == null,
                onTap: () => controller.setType(null),
              ),
              for (final type in PitchType.values)
                FilterChoice(
                  label: type.label,
                  selected: filter.type == type,
                  onTap: () => controller.setType(type),
                ),
            ]),
            FilterSection(title: S.maxPrice, children: [
              FilterChoice(
                label: S.anyPrice,
                selected: filter.maxPrice == null,
                onTap: () => controller.setMaxPrice(null),
              ),
              for (final p in FilterController.prices)
                FilterChoice(
                  label: S.price(p),
                  selected: filter.maxPrice == p,
                  onTap: () => controller.setMaxPrice(p),
                ),
            ]),
            const SizedBox(height: 24),
            PrimaryButton(
              label: S.applyFilters,
              onPressed: () => controller.apply(context),
            ),
            TextButton(
              onPressed: controller.reset,
              child: const Text(S.resetFilters),
            ),
          ],
        );
      },
    );
  }
}
