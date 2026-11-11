import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/models.dart';
import '../../../data/providers.dart';

/// Per-weekday opening hours + one slot duration for the pitch.
class WorkingHoursScreen extends ConsumerWidget {
  const WorkingHoursScreen({super.key, required this.pitchId});
  final String pitchId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hours = ref.watch(workingHoursProvider(pitchId));
    return hours.when(
      skipLoadingOnReload: true,
      data: (h) => _Editor(pitchId: pitchId, initial: h),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, __) => const Scaffold(
          body: EmptyState(icon: Icons.error_outline, title: S.somethingWrong)),
    );
  }
}

class _Day {
  _Day({required this.open, required this.from, required this.to});
  bool open;
  int from;
  int to;
}

class _Editor extends ConsumerStatefulWidget {
  const _Editor({required this.pitchId, required this.initial});
  final String pitchId;
  final List<WorkingHours> initial;

  @override
  ConsumerState<_Editor> createState() => _EditorState();
}

class _EditorState extends ConsumerState<_Editor> {
  // Egyptian week order: Saturday first.
  static const _order = [6, 0, 1, 2, 3, 4, 5];
  late final Map<int, _Day> _days;
  late int _duration;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _days = {
      for (var d = 0; d < 7; d++)
        d: () {
          final w = widget.initial.where((w) => w.dayOfWeek == d).firstOrNull;
          return _Day(open: w != null, from: w?.from ?? 960, to: w?.to ?? 0);
        }(),
    };
    _duration = widget.initial.firstOrNull?.slotDurationMinutes ?? 60;
  }

  Future<void> _pickTime(_Day day, bool isFrom) async {
    // Options every 30 min. "To" may run past midnight (until 04:00).
    final options = [
      for (var m = isFrom ? 6 * 60 : 8 * 60;
          m <= (isFrom ? 23 * 60 : 28 * 60);
          m += 30)
        m,
    ];
    final current =
        isFrom ? day.from : (day.to <= day.from ? day.to + 1440 : day.to);
    final picked = await showAppBottomSheet<int>(
      context,
      title: isFrom ? S.from : S.to,
      builder: (ctx) => SizedBox(
        height: 360,
        child: ListView(
          children: [
            for (final m in options)
              ListTile(
                selected: m == current,
                selectedColor: AppColors.primary,
                title: Text(
                  m >= 1440
                      ? '${Fmt.minutesOfDay(m)} ${S.nextDay}'
                      : Fmt.minutesOfDay(m),
                  style: Theme.of(ctx).textTheme.titleMedium,
                ),
                trailing: m == current ? const Icon(Icons.check_rounded) : null,
                onTap: () => Navigator.pop(ctx, m),
              ),
          ],
        ),
      ),
    );
    if (picked == null) return;
    setState(() => isFrom ? day.from = picked : day.to = picked % 1440);
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final hours = [
      for (final e in _days.entries)
        if (e.value.open)
          WorkingHours(
            pitchId: widget.pitchId,
            dayOfWeek: e.key,
            from: e.value.from,
            to: e.value.to,
            slotDurationMinutes: _duration,
          ),
    ];
    await ref
        .read(pitchRepositoryProvider)
        .saveWorkingHours(widget.pitchId, hours);
    ref.refreshData();
    if (!mounted) return;
    showSnack(context, S.hoursSaved);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text(S.workingHours)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(S.workingHoursHint,
              style: t.bodyMedium?.copyWith(color: AppColors.inkMuted)),
          const SizedBox(height: 14),
          Text(S.slotDurationLabel, style: t.titleMedium),
          const SizedBox(height: 8),
          SegmentedButton<int>(
            showSelectedIcon: false,
            style: SegmentedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              selectedBackgroundColor: AppColors.primaryLight,
              selectedForegroundColor: AppColors.primaryDark,
            ),
            segments: [
              for (final d in const [60, 90])
                ButtonSegment(value: d, label: Text(S.slotDuration(d))),
            ],
            selected: {_duration},
            onSelectionChanged: (s) => setState(() => _duration = s.first),
          ),
          const SizedBox(height: 20),
          for (final d in _order) ...[
            _DayRow(
              name: S.weekdays[d],
              day: _days[d]!,
              onToggle: (v) => setState(() => _days[d]!.open = v),
              onFrom: () => _pickTime(_days[d]!, true),
              onTo: () => _pickTime(_days[d]!, false),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
      bottomNavigationBar: BottomActionBar(
        child: PrimaryButton(label: S.save, loading: _saving, onPressed: _save),
      ),
    );
  }
}

class _DayRow extends StatelessWidget {
  const _DayRow({
    required this.name,
    required this.day,
    required this.onToggle,
    required this.onFrom,
    required this.onTo,
  });

  final String name;
  final _Day day;
  final ValueChanged<bool> onToggle;
  final VoidCallback onFrom;
  final VoidCallback onTo;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return AppPanel(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text(name, style: t.titleMedium)),
              Text(day.open ? S.open : S.closed,
                  style: t.bodyMedium?.copyWith(
                      color: day.open ? AppColors.primary : AppColors.inkFaint,
                      fontWeight: FontWeight.w700)),
              Switch(
                value: day.open,
                activeColor: AppColors.primary,
                onChanged: onToggle,
              ),
            ],
          ),
          if (day.open)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 8),
              child: Row(
                children: [
                  Expanded(
                      child: _TimeButton(
                          label: S.from, minutes: day.from, onTap: onFrom)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _TimeButton(
                      label: S.to,
                      minutes: day.to,
                      nextDay: day.to <= day.from,
                      onTap: onTo,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _TimeButton extends StatelessWidget {
  const _TimeButton({
    required this.label,
    required this.minutes,
    required this.onTap,
    this.nextDay = false,
  });

  final String label;
  final int minutes;
  final VoidCallback onTap;
  final bool nextDay;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Material(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: t.bodySmall),
                    Text(Fmt.minutesOfDay(minutes), style: t.titleMedium),
                    if (nextDay)
                      Text(S.nextDay,
                          style: t.bodySmall?.copyWith(fontSize: 11)),
                  ],
                ),
              ),
              const Icon(Icons.expand_more_rounded, color: AppColors.inkMuted),
            ],
          ),
        ),
      ),
    );
  }
}
