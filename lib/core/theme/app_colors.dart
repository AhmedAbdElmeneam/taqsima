import 'package:flutter/material.dart';

/// Ma3adna color palette — light theme.
abstract final class AppColors {
  // Brand — football pitch green.
  static const primary = Color(0xFF1B8A3A);
  static const primaryDark = Color(0xFF0F5C26);
  static const primaryLight = Color(0xFFE6F4EA);

  // Ink — dark navy/charcoal for text.
  static const ink = Color(0xFF1A2332);
  static const inkMuted = Color(0xFF5B6676);
  static const inkFaint = Color(0xFF98A2B0);

  // Surfaces.
  static const surface = Color(0xFFFFFFFF);
  static const background = Color(0xFFF5F7F6);
  static const border = Color(0xFFE2E7E4);
  static const borderSoft = Color(0xFFEAEFEC);

  /// Soft drop shadow for floating surfaces (cards, nav bar).
  static const shadow = Color(0x140F2A1C);

  // Semantic.
  static const success = Color(0xFF2E9E5B);
  static const successLight = Color(0xFFE3F5EA);
  static const warning = Color(0xFFF2A100);
  static const warningLight = Color(0xFFFFF4D9);
  static const error = Color(0xFFD93B3B);
  static const errorLight = Color(0xFFFCE6E6);
  static const info = Color(0xFF2F6FDE);
  static const infoLight = Color(0xFFE5EEFC);

  // Slot states (calendar + slot grid).
  static const slotAvailable = primary;
  static const slotAvailableBg = primaryLight;
  static const slotApp = info;
  static const slotAppBg = infoLight;
  static const slotManual = Color(0xFFB87400);
  static const slotManualBg = warningLight;
  static const slotBlocked = Color(0xFF7A8391);
  static const slotBlockedBg = Color(0xFFECEEF1);
}
