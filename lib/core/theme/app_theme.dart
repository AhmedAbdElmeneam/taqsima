import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_icons.dart';
import 'app_spacing.dart';
import '../widgets/app_background.dart';

abstract final class AppTheme {
  /// Builds the theme for the current [AppColors.isDark] mode.
  static ThemeData build() {
    final brightness = AppColors.isDark ? Brightness.dark : Brightness.light;
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      secondary: AppColors.ink,
      onSecondary: AppColors.surface,
      error: AppColors.error,
      surface: AppColors.surface,
      onSurface: AppColors.ink,
    );

    final base = ThemeData(
        useMaterial3: true, brightness: brightness, colorScheme: scheme);

    // Calm, compact type scale: one clear title size, everything else small.
    TextStyle cairo(double size, FontWeight w, [Color? c]) => GoogleFonts.cairo(
        fontSize: size, fontWeight: w, color: c ?? AppColors.ink, height: 1.5);

    final textTheme = GoogleFonts.cairoTextTheme(base.textTheme)
        .apply(bodyColor: AppColors.ink, displayColor: AppColors.ink)
        .copyWith(
          headlineMedium: cairo(20, FontWeight.w800),
          titleLarge: cairo(16, FontWeight.w700),
          titleMedium: cairo(14, FontWeight.w700),
          bodyLarge: cairo(14, FontWeight.w500),
          bodyMedium: cairo(13, FontWeight.w500),
          bodySmall: cairo(11.5, FontWeight.w500, AppColors.inkMuted),
          labelLarge: cairo(14, FontWeight.w700),
        );

    final rounded = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radius),
    );

    return base.copyWith(
      textTheme: textTheme,
      // Screens are transparent so the shared AppBackground shows through.
      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: AppBarTheme(
        // Transparent at rest; turns frosted white once content scrolls under.
        backgroundColor: WidgetStateColor.resolveWith((s) =>
            s.contains(WidgetState.scrolledUnder)
                // Background tint (not white) so it blends with the pitch.
                ? AppColors.background.withOpacity(.94)
                : Colors.transparent),
        surfaceTintColor: Colors.transparent,
        shadowColor: AppColors.shadow,
        foregroundColor: AppColors.ink,
        elevation: 0,
        scrolledUnderElevation: 2,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge,
        iconTheme: IconThemeData(size: 22, color: AppColors.ink),
      ),
      actionIconTheme: ActionIconThemeData(
        backButtonIconBuilder: (_) => const Icon(AppIcons.back, size: 22),
      ),
      iconTheme: IconThemeData(size: 20, color: AppColors.ink),
      cardTheme: CardTheme(
        surfaceTintColor: Colors.transparent,
        color: AppColors.card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          side: BorderSide(color: AppColors.borderSoft),
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
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
          foregroundColor: AppColors.ink,
          backgroundColor: AppColors.surface,
          side: BorderSide(color: AppColors.border),
          textStyle: textTheme.labelLarge,
          shape: rounded,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: textTheme.titleMedium,
          minimumSize: const Size(44, 44),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        hintStyle: textTheme.bodyMedium?.copyWith(color: AppColors.inkFaint),
        prefixIconColor: AppColors.inkMuted,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radius),
          borderSide: BorderSide(color: AppColors.borderSoft),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radius),
          borderSide: BorderSide(color: AppColors.borderSoft),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radius),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radius),
          borderSide: BorderSide(color: AppColors.error),
        ),
        errorStyle: textTheme.bodySmall?.copyWith(color: AppColors.error),
      ),
      chipTheme: base.chipTheme.copyWith(
        labelStyle: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        side: BorderSide(color: AppColors.borderSoft),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.primaryLight,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          textStyle: WidgetStatePropertyAll(textTheme.titleMedium),
          backgroundColor: WidgetStateProperty.resolveWith((s) =>
              s.contains(WidgetState.selected)
                  ? AppColors.primaryLight
                  : AppColors.surface),
          side: WidgetStatePropertyAll(BorderSide(color: AppColors.borderSoft)),
        ),
      ),
      tabBarTheme: TabBarTheme(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.inkMuted,
        indicatorColor: AppColors.primary,
        labelStyle: textTheme.titleMedium,
        unselectedLabelStyle: textTheme.titleMedium,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: Colors.transparent,
      ),
      listTileTheme: ListTileThemeData(
        titleTextStyle: textTheme.bodyLarge,
        iconColor: AppColors.inkMuted,
        dense: true,
      ),
      dividerTheme: DividerThemeData(color: AppColors.borderSoft, space: 1),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.ink,
        contentTextStyle:
            textTheme.bodyMedium?.copyWith(color: AppColors.surface),
        shape: rounded,
      ),
      // Every page gets its own copy of the background so pages never show
      // through each other.
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: BackgroundPageTransitionsBuilder(),
        TargetPlatform.iOS: BackgroundPageTransitionsBuilder(),
        TargetPlatform.windows: BackgroundPageTransitionsBuilder(),
        TargetPlatform.macOS: BackgroundPageTransitionsBuilder(),
        TargetPlatform.linux: BackgroundPageTransitionsBuilder(),
        TargetPlatform.fuchsia: BackgroundPageTransitionsBuilder(),
      }),
      bottomSheetTheme: BottomSheetThemeData(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.surface,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
    );
  }
}
