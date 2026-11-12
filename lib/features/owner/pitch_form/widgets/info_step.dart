part of 'pitch_form_widgets_imports.dart';

/// Step 1: name, description, area, type and amenities.
class InfoStep extends StatelessWidget {
  const InfoStep({
    super.key,
    required this.formKey,
    required this.name,
    required this.description,
    required this.areas,
    required this.area,
    required this.onArea,
    required this.type,
    required this.onType,
    required this.amenities,
    required this.onAmenity,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController name;
  final TextEditingController description;
  final List<String> areas;
  final String? area;
  final ValueChanged<String> onArea;
  final PitchType type;
  final ValueChanged<PitchType> onType;
  final Set<Amenity> amenities;
  final void Function(Amenity amenity, bool selected) onAmenity;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final label = t.bodyLarge?.copyWith(fontWeight: FontWeight.w700);
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          AppTextField(
            label: S.pitchName,
            hint: S.pitchNameHint,
            controller: name,
            validator: (v) => (v ?? '').trim().isEmpty ? S.fieldRequired : null,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: '${S.description} ${S.optional}',
            hint: S.descriptionHint,
            controller: description,
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          Text(S.area, style: label),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final a in {...areas, if (area != null) area!})
                ChoiceChip(
                  label: Text(a),
                  selected: area == a,
                  showCheckmark: false,
                  onSelected: (_) => onArea(a),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(S.pitchType, style: label),
          const SizedBox(height: 8),
          SegmentedButton<PitchType>(
            showSelectedIcon: false,
            style: SegmentedButton.styleFrom(
              minimumSize: const Size.fromHeight(46),
              selectedBackgroundColor: AppColors.primaryLight,
              selectedForegroundColor: AppColors.primaryDark,
            ),
            segments: [
              for (final value in PitchType.values)
                ButtonSegment(value: value, label: Text(value.label)),
            ],
            selected: {type},
            onSelectionChanged: (s) => onType(s.first),
          ),
          const SizedBox(height: 16),
          Text(S.amenities, style: label),
          const SizedBox(height: 8),
          for (final a in Amenity.values)
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: amenities.contains(a),
              activeColor: AppColors.primary,
              secondary: Icon(a.icon, color: AppColors.primary),
              title: Text(a.label, style: t.bodyLarge),
              onChanged: (v) => onAmenity(a, v == true),
            ),
        ],
      ),
    );
  }
}
