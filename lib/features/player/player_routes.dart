import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';

// Temporary stub — replaced by the player flow in the next step.
List<RouteBase> playerRoutes(GlobalKey<NavigatorState> rootKey) => [
      GoRoute(
        path: Routes.playerHome,
        builder: (_, __) =>
            const Scaffold(body: Center(child: Icon(Icons.construction))),
      ),
    ];
