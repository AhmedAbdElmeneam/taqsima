import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/models.dart';
import '../../features/auth/login/login_imports.dart';
import '../../features/auth/otp/otp_imports.dart';
import '../../features/auth/role_choice/role_choice_imports.dart';
import '../../features/auth/session_controller.dart';
import '../../features/owner/owner_routes.dart';
import '../../features/player/player_routes.dart';
import 'routes.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  // Bridges the Riverpod session into a Listenable for go_router.
  final session = ValueNotifier<AppUser?>(ref.read(sessionProvider));
  ref.listen(sessionProvider, (_, next) => session.value = next);
  ref.onDispose(session.dispose);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: Routes.splash,
    refreshListenable: session,
    redirect: (context, state) {
      final user = session.value;
      final loc = state.matchedLocation;
      final inAuth =
          loc == Routes.splash || loc == Routes.loginPath || loc == Routes.otp;

      if (user == null) return inAuth ? null : Routes.splash;

      final home =
          user.role == UserRole.owner ? Routes.ownerToday : Routes.playerHome;
      if (inAuth) return home;
      // Keep each role inside its own area.
      if (user.role == UserRole.owner && loc.startsWith('/player')) return home;
      if (user.role != UserRole.owner && loc.startsWith('/owner')) return home;
      return null;
    },
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (_, __) => const RoleChoiceScreen(),
      ),
      GoRoute(
        path: Routes.loginPath,
        builder: (_, state) => LoginScreen(
          role: state.uri.queryParameters['role'] == UserRole.owner.name
              ? UserRole.owner
              : UserRole.player,
        ),
      ),
      GoRoute(
        path: Routes.otp,
        builder: (_, state) => OtpScreen(args: state.extra! as OtpArgs),
      ),
      ...playerRoutes(rootNavigatorKey),
      ...ownerRoutes(rootNavigatorKey),
    ],
  );
});
