import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ma3adna/core/l10n/app_strings.dart';
import 'package:ma3adna/core/router/routes.dart';
import 'package:ma3adna/core/theme/app_colors.dart';
import 'package:ma3adna/core/theme/app_spacing.dart';
import 'package:ma3adna/core/utils/formatters.dart';
import 'package:ma3adna/core/widgets/widgets.dart';
import 'package:ma3adna/data/models/models.dart';
import 'package:ma3adna/data/providers.dart';
import 'package:ma3adna/data/repositories/repositories.dart';
import 'package:ma3adna/features/auth/session_controller.dart';
import 'package:ma3adna/features/player/filter/filter_imports.dart';
import 'package:ma3adna/features/player/player_providers.dart';

import 'widgets/player_home_widgets_imports.dart';

part 'player_home_controller.dart';
part 'player_home_screen.dart';
