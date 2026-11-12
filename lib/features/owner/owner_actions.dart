import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ma3adna/core/l10n/app_strings.dart';
import 'package:ma3adna/core/widgets/widgets.dart';
import 'package:ma3adna/data/models/models.dart';
import 'package:ma3adna/data/providers.dart';

/// Accept / reject a pending booking. Shared by the requests list and the
/// owner booking details. Rejecting asks for confirmation first.
Future<void> answerBookingRequest(
    BuildContext context, WidgetRef ref, Booking b,
    {required bool accept}) async {
  if (!accept) {
    final ok = await showConfirmSheet(context,
        title: S.rejectQ, confirmLabel: S.reject, destructive: true);
    if (!ok) return;
  }
  await ref.read(bookingRepositoryProvider).updateStatus(
      b.id, accept ? BookingStatus.confirmed : BookingStatus.cancelled);
  ref.refreshData();
  if (context.mounted) showSnack(context, accept ? S.accepted : S.rejected);
}
