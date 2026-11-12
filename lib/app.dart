import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/l10n/app_strings.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_mode.dart';
import 'core/widgets/app_scroll.dart';

class TaqsimaApp extends ConsumerStatefulWidget {
  const TaqsimaApp({super.key});

  @override
  ConsumerState<TaqsimaApp> createState() => _TaqsimaAppState();
}

class _TaqsimaAppState extends ConsumerState<TaqsimaApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Follow the phone's light/dark setting while in "auto" mode.
  @override
  void didChangePlatformBrightness() => setState(() {});

  // Keep the recent-apps name in sync if the phone language changes.
  @override
  void didChangeLocales(List<Locale>? locales) => setState(() {});

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(themeModeProvider);
    final platformDark =
        WidgetsBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark;
    final isDark = switch (mode) {
      ThemeMode.dark => true,
      ThemeMode.light => false,
      ThemeMode.system => platformDark,
    };
    // Must be set before any widget reads AppColors.
    AppColors.isDark = isDark;

    return MaterialApp.router(
      // System name (recent-apps screen) follows the phone language, like the
      // launcher label; the app UI itself stays Arabic.
      title:
          WidgetsBinding.instance.platformDispatcher.locale.languageCode == 'ar'
              ? S.appName
              : S.appNameEn,
      color: const Color(0xFF1B8A3A),
      debugShowCheckedModeBanner: false,
      scrollBehavior: const AppScrollBehavior(),
      theme: AppTheme.build(),
      themeAnimationDuration: Duration.zero,
      routerConfig: ref.watch(routerProvider),
      // Arabic only, full RTL.
      locale: const Locale('ar', 'EG'),
      supportedLocales: const [Locale('ar', 'EG')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: isDark
            ? SystemUiOverlayStyle.light
                .copyWith(statusBarColor: Colors.transparent)
            : SystemUiOverlayStyle.dark
                .copyWith(statusBarColor: Colors.transparent),
        child: Directionality(
          textDirection: TextDirection.rtl,
          // Rebuild every widget (including const ones) when the mode flips.
          child: KeyedSubtree(key: ValueKey(isDark), child: child!),
        ),
      ),
    );
  }
}
