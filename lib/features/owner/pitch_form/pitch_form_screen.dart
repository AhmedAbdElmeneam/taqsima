part of 'pitch_form_imports.dart';

/// Add / edit pitch — 5 simple steps: info, photos, location, price, theme.
class PitchFormScreen extends ConsumerWidget {
  const PitchFormScreen({super.key, this.pitchId});
  final String? pitchId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = pitchId;
    if (id == null) return const _PitchForm(initial: null);
    return ref.watch(pitchProvider(id)).when(
          data: (p) => _PitchForm(initial: p),
          loading: () => const Scaffold(body: Center(child: BallLoader())),
          error: (_, __) => const Scaffold(
              body:
                  EmptyState(icon: AppIcons.warning, title: S.somethingWrong)),
        );
  }
}

class _PitchForm extends ConsumerStatefulWidget {
  const _PitchForm({required this.initial});
  final Pitch? initial;

  @override
  ConsumerState<_PitchForm> createState() => _PitchFormState();
}

class _PitchFormState extends ConsumerState<_PitchForm> {
  late final PitchFormController controller =
      PitchFormController(ref, widget.initial);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final areas = ref.watch(areasProvider).valueOrNull ?? const <String>[];

    return ListenableBuilder(
      listenable: controller.changes,
      builder: (context, _) {
        final step = controller.step.value;
        final error = controller.stepError.value;
        // Live preview: the form (and the app) wear the picked theme.
        return PitchThemeScope(
          theme: controller.theme.value,
          child: Scaffold(
            appBar: AppBar(
                title: Text(controller.isEdit ? S.editPitch : S.addPitch)),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StepIndicator(steps: PitchFormController.steps, current: step),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: KeyedSubtree(
                      key: ValueKey(step),
                      child: _currentStep(step, areas),
                    ),
                  ),
                ),
                if (error != null) StepErrorText(error),
              ],
            ),
            bottomNavigationBar: PitchFormBottomBar(
              showBack: step > 0,
              isLast: controller.isLastStep,
              saving: controller.saving.value,
              onBack: controller.back,
              onNext: () => controller.next(context),
            ),
          ),
        );
      },
    );
  }

  /// The widget for the current step, wired to the controller.
  Widget _currentStep(int step, List<String> areas) => switch (step) {
        0 => InfoStep(
            formKey: controller.infoKey,
            name: controller.name,
            description: controller.description,
            areas: areas,
            area: controller.area.value,
            onArea: controller.setArea,
            type: controller.type.value,
            onType: controller.setType,
            amenities: controller.amenities.value,
            onAmenity: controller.toggleAmenity,
          ),
        1 => PhotosStep(
            photos: controller.photos.value,
            onAdd: () => controller.addPhotos(context),
            onRemove: controller.removePhoto,
            onMakeCover: controller.makeCover,
            onView: (p) => controller.viewPhoto(context, p),
          ),
        2 => LocationStep(
            location: controller.location.value,
            onPick: controller.pickLocation,
          ),
        3 => PriceStep(
            formKey: controller.priceKey,
            price: controller.price,
            // The price field is already in [controller.changes].
            onChanged: () {},
          ),
        _ => ThemeStep(
            selected: controller.theme.value,
            onSelect: controller.setTheme,
          ),
      };
}
