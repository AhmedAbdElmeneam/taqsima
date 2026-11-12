part of 'profile_widgets_imports.dart';

/// System / light / dark toggle.
class AppearancePanel extends StatelessWidget {
  const AppearancePanel(
      {super.key, required this.mode, required this.onChanged});

  final ThemeMode mode;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return AppPanel(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(AppIcons.appearance, size: 20, color: AppColors.inkMuted),
              const SizedBox(width: 10),
              Text(S.appearance, style: t.bodyLarge),
            ],
          ),
          const SizedBox(height: 10),
          SegmentedButton<ThemeMode>(
            showSelectedIcon: false,
            style: SegmentedButton.styleFrom(
              selectedForegroundColor: AppColors.primary,
              minimumSize: const Size.fromHeight(32),
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              textStyle: t.bodySmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            segments: const [
              ButtonSegment(
                  value: ThemeMode.system,
                  icon: Icon(AppIcons.themeAuto, size: 15),
                  label: Text(S.themeSystem)),
              ButtonSegment(
                  value: ThemeMode.light,
                  icon: Icon(AppIcons.themeLight, size: 15),
                  label: Text(S.themeLight)),
              ButtonSegment(
                  value: ThemeMode.dark,
                  icon: Icon(AppIcons.themeDark, size: 15),
                  label: Text(S.themeDark)),
            ],
            selected: {mode},
            onSelectionChanged: (s) => onChanged(s.first),
          ),
        ],
      ),
    );
  }
}
