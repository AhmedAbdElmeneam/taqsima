import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';

// Temporary stub — replaced by the owner flow in a later step.
List<RouteBase> ownerRoutes(GlobalKey<NavigatorState> rootKey) => [
      GoRoute(
        path: Routes.ownerToday,
        builder: (_, __) =>
            const Scaffold(body: Center(child: Icon(Icons.construction))),
      ),
    ];
