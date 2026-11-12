import 'package:flutter/material.dart';

import '../../data/models/models.dart';
import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../theme/app_spacing.dart';
import '../theme/pitch_palettes.dart';

/// The fixed pitch themes as a 2-column grid of swatches.
class PitchThemeGrid extends StatelessWidget {
  const PitchThemeGrid(
      {super.key, required this.selected, required this.onSelect});

  final PitchTheme selected;
  final ValueChanged<PitchTheme> onSelect;

  @override
  Widget build(BuildContext context) => GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.25,
        children: [
          for (final theme in PitchTheme.values)
            ThemeOptionCard(
              theme: theme,
              selected: theme == selected,
              onTap: () => onSelect(theme),
            ),
        ],
      );
}

/// One theme: its light and dark swatches, name and a check when chosen.
class ThemeOptionCard extends StatelessWidget {
  const ThemeOptionCard({
    super.key,
    required this.theme,
    required this.selected,
    required this.onTap,
  });

  final PitchTheme theme;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = theme.palette;
    final main = AppColors.isDark ? p.primaryNight : p.primary;
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        side: BorderSide(
          color: selected ? main : AppColors.border,
          width: selected ? 2 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    // Light mode | dark mode.
                    for (final (bg, fg) in [
                      (p.primaryLight, p.primary),
                      (p.primaryLightNight, p.primaryNight),
                    ])
                      Expanded(
                        child: Container(
                          margin: const EdgeInsetsDirectional.only(end: 6),
                          decoration: BoxDecoration(
                            color: bg,
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusSm),
                          ),
                          alignment: Alignment.center,
                          child: Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                                color: fg, shape: BoxShape.circle),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(p.label,
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  if (selected) Icon(AppIcons.check, size: 18, color: main),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

