part of 'pitch_form_imports.dart';

/// Draft pitch, step validation and saving for the add / edit wizard.
class PitchFormController {
  PitchFormController(this.ref, this.initial)
      : name = TextEditingController(text: initial?.name),
        description = TextEditingController(text: initial?.description),
        price = TextEditingController(
            text: initial?.pricePerHour.toString() ?? ''),
        area = ValueNotifier(initial?.area),
        type = ValueNotifier(initial?.type ?? PitchType.fiveASide),
        amenities = ValueNotifier({
          ...?initial?.amenities,
          if (initial == null) Amenity.artificialGrass,
        }),
        photos = ValueNotifier([...?initial?.photos]),
        location = ValueNotifier(
            initial == null ? null : (lat: initial.lat, lng: initial.lng));

  final WidgetRef ref;

  /// The pitch being edited, or null when adding a new one.
  final Pitch? initial;

  static const steps = [S.stepInfo, S.stepPhotos, S.stepLocation, S.stepPrice];

  final infoKey = GlobalKey<FormState>();
  final priceKey = GlobalKey<FormState>();

  final TextEditingController name;
  final TextEditingController description;
  final TextEditingController price;
  final ValueNotifier<String?> area;
  final ValueNotifier<PitchType> type;
  final ValueNotifier<Set<Amenity>> amenities;
  final ValueNotifier<List<String>> photos;
  final ValueNotifier<({double lat, double lng})?> location;

  final step = ValueNotifier(0);
  final saving = ValueNotifier(false);
  final stepError = ValueNotifier<String?>(null);

  bool _disposed = false;

  bool get isEdit => initial != null;
  bool get isLastStep => step.value == steps.length - 1;

  /// Everything the screen rebuilds on.
  late final Listenable changes = Listenable.merge([
    price, area, type, amenities, photos, location, step, saving, stepError,
  ]);

  void setArea(String a) => area.value = a;
  void setType(PitchType t) => type.value = t;

  void toggleAmenity(Amenity a, bool on) {
    final next = {...amenities.value};
    on ? next.add(a) : next.remove(a);
    amenities.value = next;
  }

  /// Mock: adds a placeholder image.
  void addPhoto() => photos.value = [
        ...photos.value,
        'new_${DateTime.now().microsecondsSinceEpoch}',
      ];

  void removePhoto(String p) =>
      photos.value = [...photos.value]..remove(p);

  void pickLocation(double lat, double lng) {
    location.value = (lat: lat, lng: lng);
    stepError.value = null;
  }

  void back() {
    if (step.value == 0) return;
    step.value--;
    stepError.value = null;
  }

  bool _validateStep() {
    stepError.value = null;
    switch (step.value) {
      case 0:
        final ok = infoKey.currentState!.validate();
        if (area.value == null) {
          stepError.value = S.chooseArea;
          return false;
        }
        return ok;
      case 2:
        if (location.value == null) {
          stepError.value = S.tapMapToPin;
          return false;
        }
        return true;
      case 3:
        return priceKey.currentState!.validate();
      default:
        return true;
    }
  }

  /// Validates the current step, then moves on or saves on the last one.
  Future<void> next(BuildContext context) async {
    if (!_validateStep()) return;
    if (!isLastStep) {
      step.value++;
      return;
    }
    saving.value = true;
    try {
      final base = initial;
      final loc = location.value!;
      final pitch = Pitch(
        id: base?.id ?? '',
        ownerId: base?.ownerId ?? ref.read(currentUserIdProvider),
        name: name.text.trim(),
        description: description.text.trim(),
        area: area.value!,
        lat: loc.lat,
        lng: loc.lng,
        type: type.value,
        pricePerHour: int.parse(price.text),
        photos: photos.value,
        amenities: Amenity.values.where(amenities.value.contains).toList(),
        status: base?.status ?? PitchStatus.pending,
      );
      final saved = await ref.read(pitchRepositoryProvider).savePitch(pitch);
      ref.read(selectedPitchIdProvider.notifier).state = saved.id;
      ref.refreshData();
      if (!context.mounted) return;
      showSnack(context, isEdit ? S.pitchSaved : S.pitchSubmitted);
      context.pop();
    } finally {
      if (!_disposed) saving.value = false;
    }
  }

  void dispose() {
    _disposed = true;
    for (final c in [name, description, price]) {
      c.dispose();
    }
    for (final n in <ChangeNotifier>[
      area, type, amenities, photos, location, step, saving, stepError,
    ]) {
      n.dispose();
    }
  }
}
