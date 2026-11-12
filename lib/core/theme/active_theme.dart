import 'package:flutter/widgets.dart';

import '../../data/models/models.dart';
import 'app_colors.dart';

/// Which pitch look the app shows right now.
///
/// Screens that belong to one pitch wrap themselves in [PitchThemeScope];
/// the most recently opened scope wins, and closing it falls back to the one
/// below (or the default green). The app root listens to [changes] and
/// repaints everything with the new colors (see `app.dart`).
abstract final class ActiveTheme {
  static final _stack = <(Object, PitchTheme)>[];

  /// Fires after [AppColors.theme] changes.
  static final changes = ValueNotifier<PitchTheme>(PitchTheme.green);

  static void _set(Object token, PitchTheme? theme) {
    final i = _stack.indexWhere((e) => identical(e.$1, token));
    if (theme == null) {
      if (i >= 0) _stack.removeAt(i);
    } else if (i >= 0) {
      _stack[i] = (token, theme);
    } else {
      _stack.add((token, theme));
    }
    final next = _stack.isEmpty ? PitchTheme.green : _stack.last.$2;
    if (AppColors.theme == next) return;
    // Set synchronously so the scope's own subtree builds in the new colors.
    AppColors.theme = next;
    changes.value = next;
  }
}

/// Shows [child] (and, while it is open, the whole app) in [theme].
/// A null [theme] (e.g. still loading) changes nothing.
class PitchThemeScope extends StatefulWidget {
  const PitchThemeScope({super.key, required this.theme, required this.child});

  final PitchTheme? theme;
  final Widget child;

  @override
  State<PitchThemeScope> createState() => _PitchThemeScopeState();
}

class _PitchThemeScopeState extends State<PitchThemeScope> {
  final _token = Object();

  @override
  void initState() {
    super.initState();
    ActiveTheme._set(_token, widget.theme);
  }

  @override
  void didUpdateWidget(PitchThemeScope old) {
    super.didUpdateWidget(old);
    if (old.theme != widget.theme) ActiveTheme._set(_token, widget.theme);
  }

  @override
  void dispose() {
    ActiveTheme._set(_token, null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
