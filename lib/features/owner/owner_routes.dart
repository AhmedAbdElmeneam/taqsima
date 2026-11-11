import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import 'booking/owner_booking_details_screen.dart';
import 'calendar/weekly_calendar_screen.dart';
import 'dashboard/owner_dashboard_screen.dart';
import 'pitch_form/pitch_form_screen.dart';
import 'profile/owner_profile_screen.dart';
import 'requests/booking_requests_screen.dart';
import 'shell/owner_shell.dart';
import 'working_hours/working_hours_screen.dart';

/// Owner area: 4 tabs with bottom navigation + full-screen flows on top.
List<RouteBase> ownerRoutes(GlobalKey<NavigatorState> rootKey) => [
      StatefulShellRoute.indexedStack(
        builder: (_, __, shell) => OwnerShell(shell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.ownerToday,
              builder: (_, __) => const OwnerDashboardScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.ownerCalendar,
              builder: (_, __) => const WeeklyCalendarScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.ownerRequests,
              builder: (_, __) => const BookingRequestsScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.ownerProfile,
              builder: (_, __) => const OwnerProfileScreen(),
            ),
          ]),
        ],
      ),
      GoRoute(
        path: Routes.ownerPitchForm,
        parentNavigatorKey: rootKey,
        builder: (_, s) =>
            PitchFormScreen(pitchId: s.uri.queryParameters['id']),
      ),
      GoRoute(
        path: '/owner/hours/:pitchId',
        parentNavigatorKey: rootKey,
        builder: (_, s) =>
            WorkingHoursScreen(pitchId: s.pathParameters['pitchId']!),
      ),
      GoRoute(
        path: '/owner/booking/:id',
        parentNavigatorKey: rootKey,
        builder: (_, s) =>
            OwnerBookingDetailsScreen(bookingId: s.pathParameters['id']!),
      ),
    ];
