import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_icons.dart';
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

class BookingRequestsScreen extends ConsumerStatefulWidget {
  const BookingRequestsScreen({super.key});

  @override
  ConsumerState<BookingRequestsScreen> createState() =>
      _BookingRequestsScreenState();
}

class _BookingRequestsScreenState extends ConsumerState<BookingRequestsScreen> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final all = ref.watch(ownerRequestsProvider).valueOrNull ?? const [];
    final requests = ref.watch(filteredRequestsProvider);
    final searching = ref.watch(requestSearchProvider).trim().isNotEmpty;

    final list = requests.valueOrNull;

    // Whole screen scrolls: title, search box and cards in one list.
    return TabPage(
      child: ListView(
        padding: const EdgeInsets.only(bottom: AppSpacing.navBarClearance),
        children: [
          const PageTitle(S.bookingRequests),
          // Only show the search box when there is something to search.
          if (all.isNotEmpty || searching)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: TextField(
                controller: _search,
                textInputAction: TextInputAction.search,
                onChanged: (v) =>
                    ref.read(requestSearchProvider.notifier).state = v,
                decoration: InputDecoration(
                  hintText: S.searchRequestsHint,
                  prefixIcon: const Icon(AppIcons.search, size: 20),
                  suffixIcon: searching
                      ? IconButton(
                          icon: const Icon(AppIcons.close, size: 18),
                          onPressed: () {
                            _search.clear();
                            ref.read(requestSearchProvider.notifier).state = '';
                          },
                        )
                      : null,
                ),
              ),
            ),
          if (list == null)
            const Padding(
              padding: EdgeInsets.only(top: 80),
              child: Center(child: BallLoader()),
            )
          else if (list.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: searching
                  ? const EmptyState(
                      icon: AppIcons.notFound,
                      title: S.noSearchResults,
                      message: S.noSearchResultsHint,
                    )
                  : const EmptyState(
                      icon: AppIcons.inbox,
                      title: S.noRequests,
                      message: S.noRequestsHint,
                    ),
            )
          else
            for (final (i, b) in list.indexed)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                child: FadeSlideIn(
                  index: i,
                  child: _RequestCard(key: ValueKey(b.id), booking: b),
                ),
              ),
        ],
      ),
    );
  }
}

class _RequestCard extends ConsumerStatefulWidget {
  const _RequestCard({super.key, required this.booking});
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

    return PressableScale(
      child: Card(
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
                        style:
                            t.titleMedium?.copyWith(color: AppColors.primary)),
                  ],
                ),
                const SizedBox(height: 12),
                AppPanel(
                  color: AppColors.background,
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(AppIcons.calendar, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${Fmt.dayRelative(b.startAt)} • ${Fmt.timeRange(b.startAt, b.endAt)}',
                          style: t.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
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
                        compact: true,
                        icon: AppIcons.check,
                        loading: _busy,
                        onPressed: () => _answer(true),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SecondaryButton(
                        label: S.reject,
                        compact: true,
                        icon: AppIcons.close,
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
      ),
    );
  }
}
