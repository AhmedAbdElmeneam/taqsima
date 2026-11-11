import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../data/models/models.dart';
import '../profile/profile_screen.dart';
import 'booking/booking_confirm_screen.dart';
import 'booking/booking_success_screen.dart';
import 'booking/my_bookings_screen.dart';
import 'booking/player_booking_details_screen.dart';
import 'booking/slot_picker_screen.dart';
import 'home/player_home_screen.dart';
import 'pitch/pitch_details_screen.dart';
import 'search/search_screen.dart';
import 'shell/player_shell.dart';

/// Player area: 4 tabs with bottom navigation + full-screen flows on top.
List<RouteBase> playerRoutes(GlobalKey<NavigatorState> rootKey) => [
      StatefulShellRoute.indexedStack(
        builder: (_, __, shell) => PlayerShell(shell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.playerHome,
              builder: (_, __) => const PlayerHomeScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.playerSearch,
              builder: (_, __) => const SearchScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.playerBookings,
              builder: (_, __) => const MyBookingsScreen(),
              routes: [
                GoRoute(
                  path: ':id',
                  parentNavigatorKey: rootKey,
                  builder: (_, s) => PlayerBookingDetailsScreen(
                      bookingId: s.pathParameters['id']!),
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.playerProfile,
              builder: (_, __) => const ProfileScreen(),
            ),
          ]),
        ],
      ),
      GoRoute(
        path: '/player/pitch/:id',
        parentNavigatorKey: rootKey,
        builder: (_, s) => PitchDetailsScreen(pitchId: s.pathParameters['id']!),
        routes: [
          GoRoute(
            path: 'slots',
            parentNavigatorKey: rootKey,
            builder: (_, s) =>
                SlotPickerScreen(pitchId: s.pathParameters['id']!),
          ),
        ],
      ),
      GoRoute(
        path: Routes.confirmBooking,
        parentNavigatorKey: rootKey,
        builder: (_, s) => BookingConfirmScreen(slot: s.extra! as TimeSlot),
      ),
      GoRoute(
        path: '/player/success/:id',
        parentNavigatorKey: rootKey,
        builder: (_, s) =>
            BookingSuccessScreen(bookingId: s.pathParameters['id']!),
      ),
    ];
