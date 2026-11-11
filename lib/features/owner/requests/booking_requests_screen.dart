import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_strings.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/models.dart';
import '../../../data/providers.dart';
import '../owner_providers.dart';

/// Accept / reject a pending booking. Shared by the list and details screens.
Future<void> answerRequest(BuildContext context, WidgetRef ref, Booking b,
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

class BookingRequestsScreen extends ConsumerWidget {
  const BookingRequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requests = ref.watch(ownerRequestsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text(S.bookingRequests)),
      body: AsyncView(
        value: requests,
        builder: (list) => list.isEmpty
            ? const EmptyState(
                icon: Icons.inbox_outlined,
                title: S.noRequests,
                message: S.noRequestsHint,
              )
            : ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => _RequestCard(booking: list[i]),
              ),
      ),
    );
  }
}

class _RequestCard extends ConsumerStatefulWidget {
  const _RequestCard({required this.booking});
  final Booking booking;

  @override
  ConsumerState<_RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends ConsumerState<_RequestCard> {
  bool _busy = false;

  Future<void> _answer(bool accept) async {
    setState(() => _busy = true);
    try {
      await answerRequest(context, ref, widget.booking, accept: accept);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final b = widget.booking;
    final player = ref.watch(userProvider(b.userId ?? '')).valueOrNull;
    final pitch = ref.watch(pitchProvider(b.pitchId)).valueOrNull;
    final t = Theme.of(context).textTheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(Routes.ownerBooking(b.id)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.infoLight,
                    child: Text(
                      (player?.name ?? ' ').characters.first,
                      style: t.titleLarge?.copyWith(color: AppColors.info),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(player?.name ?? '', style: t.titleMedium),
                        Text(pitch?.name ?? '',
                            style: t.bodyMedium
                                ?.copyWith(color: AppColors.inkMuted)),
                      ],
                    ),
                  ),
                  Text(S.price(b.price),
                      style: t.titleMedium?.copyWith(color: AppColors.primary)),
                ],
              ),
              const SizedBox(height: 12),
              AppPanel(
                color: AppColors.background,
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const Icon(Icons.event_rounded, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${Fmt.dayRelative(b.startAt)} • ${Fmt.timeRange(b.startAt, b.endAt)}',
                        style:
                            t.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      label: S.accept,
                      icon: Icons.check_rounded,
                      loading: _busy,
                      onPressed: () => _answer(true),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SecondaryButton(
                      label: S.reject,
                      icon: Icons.close_rounded,
                      color: AppColors.error,
                      onPressed: _busy ? null : () => _answer(false),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
