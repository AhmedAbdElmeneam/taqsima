import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/labels.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/models.dart';
import '../../../data/providers.dart';
import '../../auth/session_controller.dart';
import '../owner_providers.dart';

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
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, __) => const Scaffold(
          body: EmptyState(icon: Icons.error_outline, title: S.somethingWrong)),
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
                child: switch (_step) {
                  0 => _infoStep(),
                  1 => _photosStep(),
                  2 => _locationStep(),
                  _ => _priceStep(),
                },
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

  Widget _infoStep() {
    final areas = ref.watch(areasProvider).valueOrNull ?? const [];
    final t = Theme.of(context).textTheme;
    return Form(
      key: _infoKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          AppTextField(
            label: S.pitchName,
            hint: S.pitchNameHint,
            controller: _name,
            validator: (v) => (v ?? '').trim().isEmpty ? S.fieldRequired : null,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: '${S.description} ${S.optional}',
            hint: S.descriptionHint,
            controller: _desc,
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          Text(S.area,
              style: t.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final a in {...areas, if (_area != null) _area!})
                ChoiceChip(
                  label: Text(a),
                  selected: _area == a,
                  showCheckmark: false,
                  onSelected: (_) => setState(() => _area = a),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(S.pitchType,
              style: t.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          SegmentedButton<PitchType>(
            showSelectedIcon: false,
            style: SegmentedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              selectedBackgroundColor: AppColors.primaryLight,
              selectedForegroundColor: AppColors.primaryDark,
            ),
            segments: [
              for (final type in PitchType.values)
                ButtonSegment(value: type, label: Text(type.label)),
            ],
            selected: {_type},
            onSelectionChanged: (s) => setState(() => _type = s.first),
          ),
          const SizedBox(height: 16),
          Text(S.amenities,
              style: t.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          for (final a in Amenity.values)
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: _amenities.contains(a),
              activeColor: AppColors.primary,
              secondary: Icon(a.icon, color: AppColors.primary),
              title: Text(a.label, style: t.bodyLarge),
              onChanged: (v) => setState(
                  () => v == true ? _amenities.add(a) : _amenities.remove(a)),
            ),
        ],
      ),
    );
  }

  Widget _photosStep() {
    final t = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(S.photosHint,
            style: t.bodyMedium?.copyWith(color: AppColors.inkMuted)),
        const SizedBox(height: 14),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.3,
          children: [
            for (final photo in _photos)
              Stack(
                children: [
                  Positioned.fill(
                    child: PitchImage(
                        photoKey: photo,
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  PositionedDirectional(
                    top: 6,
                    end: 6,
                    child: IconButton.filled(
                      style:
                          IconButton.styleFrom(backgroundColor: Colors.black54),
                      icon: const Icon(Icons.close_rounded, size: 18),
                      onPressed: () => setState(() => _photos.remove(photo)),
                    ),
                  ),
                ],
              ),
            Material(
              color: AppColors.primaryLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppColors.primary, width: 1.5),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => setState(() => _photos
                    .add('new_${DateTime.now().microsecondsSinceEpoch}')),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_a_photo_outlined,
                        size: 36, color: AppColors.primary),
                    const SizedBox(height: 6),
                    Text(S.addPhoto,
                        style:
                            t.titleMedium?.copyWith(color: AppColors.primary)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _locationStep() {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                _location == null
                    ? Icons.touch_app_rounded
                    : Icons.check_circle_rounded,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(_location == null ? S.tapMapToPin : S.locationSet,
                    style: t.titleMedium),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: MapPlaceholder(
              picked: _location,
              onPick: (lat, lng) => setState(() {
                _location = (lat: lat, lng: lng);
                _stepError = null;
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceStep() {
    const quick = [250, 300, 350, 400, 500, 600];
    return Form(
      key: _priceKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          AppTextField(
            label: S.priceLabel,
            hint: S.priceHint,
            controller: _price,
            keyboardType: TextInputType.number,
            textDirection: TextDirection.ltr,
            prefixIcon: Icons.payments_outlined,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(5),
            ],
            onChanged: (_) => setState(() {}),
            validator: (v) {
              final n = int.tryParse(v ?? '');
              return n == null || n <= 0 ? S.invalidPrice : null;
            },
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final p in quick)
                ChoiceChip(
                  label: Text(S.price(p)),
                  selected: _price.text == '$p',
                  showCheckmark: false,
                  onSelected: (_) => setState(() => _price.text = '$p'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
