import 'package:flutter/material.dart';

/// Ma3adna color palette with a light and a dark variant.
///
/// Every color is a getter that reads [isDark], which the app root sets
/// before building (see `app.dart`). The whole app is rebuilt when the mode
/// changes, so widgets can keep using `AppColors.x` directly.
abstract final class AppColors {
  static bool isDark = false;

  /// Fixed dark text for chips drawn over pitch photos (same in both modes).
  static const onPhotoInk = Color(0xFF1A2332);

  static Color _c(int light, int dark) => Color(isDark ? dark : light);

  // Brand — football pitch green (brighter in dark mode for contrast).
  static Color get primary => _c(0xFF1B8A3A, 0xFF22A04E);
  static Color get primaryDark => _c(0xFF0F5C26, 0xFF167A3A);
  static Color get primaryLight => _c(0xFFE6F4EA, 0xFF173525);

  /// Text/icons drawn on top of [primary].
  static Color get onPrimary => const Color(0xFFFFFFFF);

  // Ink — text.
  static Color get ink => _c(0xFF1A2332, 0xFFE7EEE9);
  static Color get inkMuted => _c(0xFF5B6676, 0xFF9DAAA3);
  static Color get inkFaint => _c(0xFF98A2B0, 0xFF66736C);

  // Surfaces.
  static Color get surface => _c(0xFFFFFFFF, 0xFF18211C);

  /// Card fill: slightly see-through so the pitch background shows behind.
  static Color get card => isDark
      ? const Color(0xFF18211C).withOpacity(.82)
      : Colors.white.withOpacity(.80);
  static Color get surfaceRaised => _c(0xFFFFFFFF, 0xFF1F2A24);
  static Color get background => _c(0xFFF5F7F6, 0xFF0D1410);
  static Color get border => _c(0xFFE2E7E4, 0xFF2B3731);
  static Color get borderSoft => _c(0xFFEAEFEC, 0xFF232E28);

  /// Soft drop shadow for floating surfaces (cards, nav bar).
  static Color get shadow => _c(0x140F2A1C, 0x66000000);

  /// Frosted glass fill (nav bar, floating action bar, scrolled app bar).
  static Color get glass => isDark
      ? const Color(0xFF18211C).withOpacity(.78)
      : Colors.white.withOpacity(.74);
  static Color get glassBorder =>
      isDark ? Colors.white.withOpacity(.08) : Colors.white.withOpacity(.9);

  // Semantic.
  static Color get success => _c(0xFF2E9E5B, 0xFF4CD483);
  static Color get successLight => _c(0xFFE3F5EA, 0xFF173A26);
  static Color get warning => _c(0xFFF2A100, 0xFFF5B83D);
  static Color get warningLight => _c(0xFFFFF4D9, 0xFF3A2F14);
  static Color get error => _c(0xFFD93B3B, 0xFFF26B6B);
  static Color get errorLight => _c(0xFFFCE6E6, 0xFF3D1D1F);
  static Color get info => _c(0xFF2F6FDE, 0xFF6A9DF5);
  static Color get infoLight => _c(0xFFE5EEFC, 0xFF18284A);

  // Slot states (calendar + slot grid).
  static Color get slotAvailable => primary;
  static Color get slotAvailableBg => primaryLight;
  static Color get slotApp => info;
  static Color get slotAppBg => infoLight;
  static Color get slotManual => _c(0xFFB87400, 0xFFE8AA4E);
  static Color get slotManualBg => warningLight;
  static Color get slotBlocked => _c(0xFF7A8391, 0xFF8E99A6);
  static Color get slotBlockedBg => _c(0xFFECEEF1, 0xFF252C31);
}
