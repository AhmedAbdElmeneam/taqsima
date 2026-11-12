import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../data/models/models.dart';
import '../pitch_themed.dart';
import '../profile/profile_imports.dart';
import 'booking/booking_confirm/booking_confirm_imports.dart';
import 'booking/booking_success/booking_success_imports.dart';
import 'booking/my_bookings/my_bookings_imports.dart';
import 'booking/booking_details/player_booking_details_imports.dart';
import 'booking/slot_picker/slot_picker_imports.dart';
import 'home/player_home_imports.dart';
import 'pitch/pitch_details_imports.dart';
import 'search/search_imports.dart';
import 'shell/player_shell_imports.dart';

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
                  builder: (_, s) => BookingPitchThemed(
                    bookingId: s.pathParameters['id']!,
                    child: PlayerBookingDetailsScreen(
                        bookingId: s.pathParameters['id']!),
                  ),
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
        builder: (_, s) => PitchThemed(
          pitchId: s.pathParameters['id']!,
          child: PitchDetailsScreen(pitchId: s.pathParameters['id']!),
        ),
        routes: [
          GoRoute(
            path: 'slots',
            parentNavigatorKey: rootKey,
            builder: (_, s) => PitchThemed(
              pitchId: s.pathParameters['id']!,
              child: SlotPickerScreen(pitchId: s.pathParameters['id']!),
            ),
          ),
        ],
      ),
      GoRoute(
        path: Routes.confirmBooking,
        parentNavigatorKey: rootKey,
        builder: (_, s) {
          final slot = s.extra! as TimeSlot;
          return PitchThemed(
              pitchId: slot.pitchId, child: BookingConfirmScreen(slot: slot));
        },
      ),
      GoRoute(
        path: '/player/success/:id',
        parentNavigatorKey: rootKey,
        builder: (_, s) => BookingPitchThemed(
          bookingId: s.pathParameters['id']!,
          child: BookingSuccessScreen(bookingId: s.pathParameters['id']!),
        ),
      ),
    ];
