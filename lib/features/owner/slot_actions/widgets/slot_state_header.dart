part of 'slot_actions_widgets_imports.dart';

/// Coloured panel: slot state label + name / reason.
class SlotStateHeader extends StatelessWidget {
  const SlotStateHeader({super.key, required this.state, required this.text});

  final SlotState state;
  final String text;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return AppPanel(
      color: state.background,
      child: Row(
        children: [
          Icon(state.icon, color: state.color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(state.label,
                    style: t.bodyMedium?.copyWith(
                        color: state.color, fontWeight: FontWeight.w700)),
                Text(text, style: t.titleLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
