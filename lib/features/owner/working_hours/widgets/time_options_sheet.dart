part of 'working_hours_widgets_imports.dart';

/// Scrollable list of times; pops the picked minutes.
class TimeOptionsSheet extends StatelessWidget {
  const TimeOptionsSheet(
      {super.key, required this.options, required this.current});

  final List<int> options;
  final int current;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                style: Theme.of(context).textTheme.titleMedium,
              ),
              trailing: m == current ? const Icon(AppIcons.check) : null,
              onTap: () => Navigator.pop(context, m),
            ),
        ],
      ),
    );
  }
}
