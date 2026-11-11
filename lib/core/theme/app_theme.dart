import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_spacing.dart';

abstract final class AppTheme {
  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.ink,
      onSecondary: Colors.white,
      error: AppColors.error,
      surface: AppColors.surface,
      onSurface: AppColors.ink,
    );

    final base = ThemeData(useMaterial3: true, colorScheme: scheme);
    final textTheme = GoogleFonts.cairoTextTheme(base.textTheme)
        .apply(bodyColor: AppColors.ink, displayColor: AppColors.ink)
        .copyWith(
          headlineMedium: GoogleFonts.cairo(
              fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.ink),
          titleLarge: GoogleFonts.cairo(
              fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.ink),
          titleMedium: GoogleFonts.cairo(
              fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.ink),
          bodyLarge: GoogleFonts.cairo(fontSize: 16, color: AppColors.ink),
          bodyMedium: GoogleFonts.cairo(fontSize: 14, color: AppColors.ink),
          bodySmall: GoogleFonts.cairo(fontSize: 12, color: AppColors.inkMuted),
          labelLarge:
              GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w700),
        );

    final rounded = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radius),
    );

    return base.copyWith(
      textTheme: textTheme,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardTheme(
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.border,
          textStyle: textTheme.labelLarge,
          shape: rounded,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
          foregroundColor: AppColors.ink,
          side: const BorderSide(color: AppColors.border, width: 1.5),
          textStyle: textTheme.labelLarge,
          shape: rounded,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: textTheme.labelLarge,
          minimumSize: const Size(48, 48),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: textTheme.bodyLarge?.copyWith(color: AppColors.inkFaint),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radius),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radius),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radius),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radius),
          borderSide: const BorderSide(color: AppColors.error),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        labelStyle: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.primaryLight,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primaryLight,
        labelTextStyle: WidgetStatePropertyAll(
          textTheme.bodySmall
              ?.copyWith(fontWeight: FontWeight.w700, color: AppColors.ink),
        ),
      ),
      tabBarTheme: TabBarTheme(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.inkMuted,
        indicatorColor: AppColors.primary,
        labelStyle: textTheme.titleMedium,
        unselectedLabelStyle: textTheme.titleMedium,
        indicatorSize: TabBarIndicatorSize.tab,
      ),
      dividerTheme: const DividerThemeData(color: AppColors.border, space: 1),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.ink,
        contentTextStyle: textTheme.bodyLarge?.copyWith(color: Colors.white),
        shape: rounded,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        showDragHandle: true,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLg)),
        ),
      ),
    );
  }
}
