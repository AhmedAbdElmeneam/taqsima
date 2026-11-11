import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Light / dark / follow-the-phone. Kept in memory for this prototype;
/// persist it (e.g. shared_preferences) when real settings storage is added.
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);
