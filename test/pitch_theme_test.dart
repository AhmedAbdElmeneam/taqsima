import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ma3adna/core/theme/active_theme.dart';
import 'package:ma3adna/core/theme/app_colors.dart';
import 'package:ma3adna/core/theme/pitch_palettes.dart';
import 'package:ma3adna/data/models/models.dart';

void main() {
  testWidgets('the newest open pitch scope wins, closing restores',
      (tester) async {
    Widget app(List<PitchTheme?> scopes) {
      Widget child = const SizedBox();
      for (final t in scopes.reversed) {
        child = PitchThemeScope(theme: t, child: child);
      }
      return Directionality(textDirection: TextDirection.rtl, child: child);
    }

    expect(AppColors.theme, PitchTheme.green);

    // Owner side (navy) with a pitch screen (maroon) open on top.
    await tester.pumpWidget(app([PitchTheme.navy, PitchTheme.maroon]));
    expect(AppColors.theme, PitchTheme.maroon);
    expect(AppColors.primary, PitchTheme.maroon.palette.primary);

    // Pitch screen closed → back to the owner's navy.
    await tester.pumpWidget(app([PitchTheme.navy]));
    expect(AppColors.theme, PitchTheme.navy);

    // Still loading (null) changes nothing → default green.
    await tester.pumpWidget(app([null]));
    expect(AppColors.theme, PitchTheme.green);
  });

  test('every theme has distinct light and dark primaries', () {
    final primaries = PitchTheme.values.map((t) => t.palette.primary).toSet();
    expect(primaries.length, PitchTheme.values.length);
    for (final t in PitchTheme.values) {
      expect(t.palette.washLight, hasLength(3));
      expect(t.palette.washNight, hasLength(3));
    }
  });
}
