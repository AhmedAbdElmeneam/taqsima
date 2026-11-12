import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/l10n/app_strings.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Name and brand color shown for the app in the recent-apps screen.
  SystemChrome.setApplicationSwitcherDescription(
    const ApplicationSwitcherDescription(
      label: S.appName,
      primaryColor: 0xFF1B8A3A,
    ),
  );
  runApp(const ProviderScope(child: Ma3adnaApp()));
}
