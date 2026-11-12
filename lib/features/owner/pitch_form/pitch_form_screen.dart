import 'package:flutter/material.dart';
import '../../../core/theme/app_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/models.dart';
import '../../../data/providers.dart';
import '../../auth/session_controller.dart';
import '../owner_providers.dart';
import 'steps/info_step.dart';
import 'steps/location_step.dart';
import 'steps/photos_step.dart';
import 'steps/price_step.dart';

/// Add / edit pitch — 4 simple steps: info, photos, location, price.
class PitchFormScreen extends ConsumerWidget {
  const PitchFormScreen({super.key, this.pitchId});
  final String? pitchId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (pitchId == null) return const _PitchForm(initial: null);
    final pitch = ref.watch(pitchProvider(pitchId!));
    return pitch.when(
      data: (p) => _PitchForm(initial: p),
      loading: () => const Scaffold(body: Center(child: BallLoader())),
      error: (_, __) => const Scaffold(
          body: EmptyState(icon: AppIcons.warning, title: S.somethingWrong)),
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
  static const _steps = [S.stepInfo, S.stepPhotos, S.stepLocation, S.stepPrice];
  final _infoKey = GlobalKey<FormState>();
  final _priceKey = GlobalKey<FormState>();

  late final _name = TextEditingController(text: widget.initial?.name);
  late final _desc = TextEditingController(text: widget.initial?.description);
  late final _price = TextEditingController(
      text: widget.initial?.pricePerHour.toString() ?? '');
  late String? _area = widget.initial?.area;
  late PitchType _type = widget.initial?.type ?? PitchType.fiveASide;
  late final Set<Amenity> _amenities = {
    ...?widget.initial?.amenities,
    if (widget.initial == null) Amenity.artificialGrass
  };
  late final List<String> _photos = [...?widget.initial?.photos];
  late ({double lat, double lng})? _location = widget.initial == null
      ? null
      : (lat: widget.initial!.lat, lng: widget.initial!.lng);

  int _step = 0;
  bool _saving = false;
  String? _stepError;

  bool get _isEdit => widget.initial != null;

  @override
  void dispose() {
    _name.dispose();
    _desc.dispose();
    _price.dispose();
    super.dispose();
  }

  bool _validateStep() {
    setState(() => _stepError = null);
    switch (_step) {
      case 0:
        final ok = _infoKey.currentState!.validate();
        if (_area == null) {
          setState(() => _stepError = S.chooseArea);
          return false;
        }
        return ok;
      case 2:
        if (_location == null) {
          setState(() => _stepError = S.tapMapToPin);
          return false;
        }
        return true;
      case 3:
        return _priceKey.currentState!.validate();
      default:
        return true;
    }
  }

  Future<void> _next() async {
    if (!_validateStep()) return;
    if (_step < _steps.length - 1) {
      setState(() => _step++);
      return;
    }
    setState(() => _saving = true);
    final base = widget.initial;
    final pitch = Pitch(
      id: base?.id ?? '',
      ownerId: base?.ownerId ?? ref.read(currentUserIdProvider),
      name: _name.text.trim(),
      description: _desc.text.trim(),
      area: _area!,
      lat: _location!.lat,
      lng: _location!.lng,
      type: _type,
      pricePerHour: int.parse(_price.text),
      photos: _photos,
      amenities: Amenity.values.where(_amenities.contains).toList(),
      status: base?.status ?? PitchStatus.pending,
    );
    final saved = await ref.read(pitchRepositoryProvider).savePitch(pitch);
    ref.read(selectedPitchIdProvider.notifier).state = saved.id;
    ref.refreshData();
    if (!mounted) return;
    showSnack(context, _isEdit ? S.pitchSaved : S.pitchSubmitted);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? S.editPitch : S.addPitch)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: Row(
              children: [
                for (var i = 0; i < _steps.length; i++) ...[
                  Expanded(
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          height: 6,
                          decoration: BoxDecoration(
                            color: i <= _step
                                ? AppColors.primary
                                : AppColors.border,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(_steps[i],
                            style: t.bodySmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: i == _step
                                  ? AppColors.primary
                                  : AppColors.inkMuted,
                            )),
                      ],
                    ),
                  ),
                  if (i < _steps.length - 1) const SizedBox(width: 6),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(S.stepOf(_step + 1, _steps.length), style: t.bodySmall),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: KeyedSubtree(
                key: ValueKey(_step),
                child: _currentStep(),
              ),
            ),
          ),
          if (_stepError != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Text(_stepError!,
                  textAlign: TextAlign.center,
                  style: t.bodyMedium?.copyWith(color: AppColors.error)),
            ),
        ],
      ),
      bottomNavigationBar: BottomActionBar(
        child: Row(
          children: [
            if (_step > 0) ...[
              Expanded(
                flex: 2,
                child: SecondaryButton(
                  label: S.back,
                  onPressed: () => setState(() {
                    _step--;
                    _stepError = null;
                  }),
                ),
              ),
              const SizedBox(width: 10),
            ],
            Expanded(
              flex: 3,
              child: PrimaryButton(
                label: _step == _steps.length - 1 ? S.finish : S.next,
                loading: _saving,
                onPressed: _next,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// The widget for the current step, wired to this form's state.
  Widget _currentStep() => switch (_step) {
        0 => InfoStep(
            formKey: _infoKey,
            name: _name,
            description: _desc,
            areas: ref.watch(areasProvider).valueOrNull ?? const [],
            area: _area,
            onArea: (a) => setState(() => _area = a),
            type: _type,
            onType: (t) => setState(() => _type = t),
            amenities: _amenities,
            onAmenity: (a, on) =>
                setState(() => on ? _amenities.add(a) : _amenities.remove(a)),
          ),
        1 => PhotosStep(
            photos: _photos,
            onAdd: () => setState(() =>
                _photos.add('new_${DateTime.now().microsecondsSinceEpoch}')),
            onRemove: (p) => setState(() => _photos.remove(p)),
          ),
        2 => LocationStep(
            location: _location,
            onPick: (lat, lng) => setState(() {
              _location = (lat: lat, lng: lng);
              _stepError = null;
            }),
          ),
        _ => PriceStep(
            formKey: _priceKey,
            price: _price,
            onChanged: () => setState(() {}),
          ),
      };
}
