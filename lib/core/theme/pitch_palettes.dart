import 'package:flutter/material.dart';

import '../../data/models/models.dart';

/// Brand colors of one [PitchTheme], for light and dark mode.
///
/// Every palette stays clear of the fixed slot colors (blue = app booking,
/// purple = manual, grey = blocked) so the calendar always reads the same.
class PitchPalette {
  const PitchPalette({
    required this.label,
    required this.primary,
    required this.primaryDark,
    required this.primaryLight,
    required this.primaryNight,
    required this.primaryDarkNight,
    required this.primaryLightNight,
    required this.washLight,
    required this.washNight,
  });

  final String label;

  // Light mode.
  final Color primary;
  final Color primaryDark;
  final Color primaryLight;

  // Dark mode (brighter primary for contrast on dark surfaces).
  final Color primaryNight;
  final Color primaryDarkNight;
  final Color primaryLightNight;

  /// Top / middle / bottom tint of the app background.
  final List<Color> washLight;
  final List<Color> washNight;
}

extension PitchThemePalette on PitchTheme {
  PitchPalette get palette => switch (this) {
        PitchTheme.green => const PitchPalette(
            label: 'أخضر الملعب',
            primary: Color(0xFF1B8A3A),
            primaryDark: Color(0xFF0F5C26),
            primaryLight: Color(0xFFE6F4EA),
            primaryNight: Color(0xFF22A04E),
            primaryDarkNight: Color(0xFF167A3A),
            primaryLightNight: Color(0xFF173525),
            washLight: [Color(0xFFDDF0E2), Color(0xFFEDF5EF), Color(0xFFE2F1E6)],
            washNight: [Color(0xFF10251A), Color(0xFF0D1913), Color(0xFF0F2117)],
          ),
        PitchTheme.teal => const PitchPalette(
            label: 'فيروزي',
            primary: Color(0xFF0B7F7A),
            primaryDark: Color(0xFF065753),
            primaryLight: Color(0xFFE1F3F2),
            primaryNight: Color(0xFF1FA39C),
            primaryDarkNight: Color(0xFF128A84),
            primaryLightNight: Color(0xFF123331),
            washLight: [Color(0xFFDBF0EF), Color(0xFFEDF6F5), Color(0xFFE0F1F0)],
            washNight: [Color(0xFF0E2423), Color(0xFF0C1817), Color(0xFF0E201F)],
          ),
        PitchTheme.navy => const PitchPalette(
            label: 'كحلي',
            primary: Color(0xFF233F7A),
            primaryDark: Color(0xFF162851),
            primaryLight: Color(0xFFE6EBF5),
            primaryNight: Color(0xFF6A85C9),
            primaryDarkNight: Color(0xFF4C68AD),
            primaryLightNight: Color(0xFF1B2540),
            washLight: [Color(0xFFDFE5F1), Color(0xFFEEF1F7), Color(0xFFE3E8F2)],
            washNight: [Color(0xFF111A2C), Color(0xFF0D131F), Color(0xFF101828)],
          ),
        PitchTheme.maroon => const PitchPalette(
            label: 'عنابي',
            primary: Color(0xFF8E2341),
            primaryDark: Color(0xFF5F152A),
            primaryLight: Color(0xFFF7E8EC),
            primaryNight: Color(0xFFC9506B),
            primaryDarkNight: Color(0xFFAA3B55),
            primaryLightNight: Color(0xFF3A1A23),
            washLight: [Color(0xFFF2E0E5), Color(0xFFF7EFF1), Color(0xFFF3E4E8)],
            washNight: [Color(0xFF26121A), Color(0xFF1A0E12), Color(0xFF221117)],
          ),
        PitchTheme.orange => const PitchPalette(
            label: 'برتقالي',
            primary: Color(0xFFC4560C),
            primaryDark: Color(0xFF853906),
            primaryLight: Color(0xFFFCEDE2),
            primaryNight: Color(0xFFE07A30),
            primaryDarkNight: Color(0xFFC0651F),
            primaryLightNight: Color(0xFF3B2414),
            washLight: [Color(0xFFF8E6D8), Color(0xFFFAF2EC), Color(0xFFF8E9DE)],
            washNight: [Color(0xFF261A10), Color(0xFF1A130D), Color(0xFF22170F)],
          ),
        PitchTheme.gold => const PitchPalette(
            label: 'ذهبي',
            primary: Color(0xFF8C6A12),
            primaryDark: Color(0xFF5E470B),
            primaryLight: Color(0xFFF7F0DD),
            primaryNight: Color(0xFFB8902A),
            primaryDarkNight: Color(0xFFA9842A),
            primaryLightNight: Color(0xFF342B14),
            washLight: [Color(0xFFF1E9D3), Color(0xFFF7F3E8), Color(0xFFF2EBD8)],
            washNight: [Color(0xFF221D0F), Color(0xFF17140C), Color(0xFF1F1A0F)],
          ),
      };
}
