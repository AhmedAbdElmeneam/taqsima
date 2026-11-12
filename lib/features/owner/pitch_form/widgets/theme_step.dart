part of 'pitch_form_widgets_imports.dart';

/// Step 5: pick one of the fixed pitch themes. The whole form re-colors
/// live, so the owner sees the choice before saving.
class ThemeStep extends StatelessWidget {
  const ThemeStep({super.key, required this.selected, required this.onSelect});

  final PitchTheme selected;
  final ValueChanged<PitchTheme> onSelect;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(S.themeHint,
            style: t.bodyMedium?.copyWith(color: AppColors.inkMuted)),
        const SizedBox(height: 14),
        PitchThemeGrid(selected: selected, onSelect: onSelect),
        const SizedBox(height: 20),
        const ThemePreview(),
      ],
    );
  }
}

/// A tiny pitch card + slots + button in the current colors.
class ThemePreview extends StatelessWidget {
  const ThemePreview({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return AppPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(S.themePreviewTitle, style: t.titleMedium),
          const SizedBox(height: 10),
          Row(
            children: [
              for (final (label, free) in [
                ('8:00', true),
                ('9:00', false),
                ('10:00', true),
              ])
                Expanded(
                  child: Container(
                    margin: const EdgeInsetsDirectional.only(end: 8),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: free
                          ? AppColors.slotAvailableBg
                          : AppColors.slotAppBg,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    alignment: Alignment.center,
                    child: Text(label,
                        style: t.titleMedium?.copyWith(
                            color: free
                                ? AppColors.slotAvailable
                                : AppColors.slotApp)),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          PrimaryButton(label: S.themePreviewButton, onPressed: () {}),
        ],
      ),
    );
  }
}
