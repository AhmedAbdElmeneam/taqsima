part of 'filter_imports.dart';

/// Draft filters edited in the sheet; written to the providers on apply.
class FilterController {
  FilterController(this.ref)
      : filter = ValueNotifier(ref.read(searchFilterProvider)),
        date = ValueNotifier(ref.read(selectedDateProvider));

  final WidgetRef ref;
  final ValueNotifier<PitchFilter> filter;
  final ValueNotifier<DateTime> date;

  static const prices = [300, 400, 500, 700];
  static const dayCount = 5;

  DateTime get today => Fmt.dateOnly(DateTime.now());

  List<DateTime> get days =>
      [for (var i = 0; i < dayCount; i++) today.add(Duration(days: i))];

  void setDate(DateTime d) => date.value = d;
  void setArea(String? area) =>
      filter.value = filter.value.copyWith(area: () => area);
  void setType(PitchType? type) =>
      filter.value = filter.value.copyWith(type: () => type);
  void setMaxPrice(int? price) =>
      filter.value = filter.value.copyWith(maxPrice: () => price);

  /// Clears everything except the typed search text.
  void reset() {
    filter.value = PitchFilter(query: filter.value.query);
    date.value = today;
  }

  void apply(BuildContext context) {
    ref.read(searchFilterProvider.notifier).state = filter.value;
    ref.read(selectedDateProvider.notifier).state = date.value;
    Navigator.pop(context, true);
  }

  void dispose() {
    filter.dispose();
    date.dispose();
  }
}
