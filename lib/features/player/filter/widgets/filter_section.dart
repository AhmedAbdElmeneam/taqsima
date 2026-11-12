part of 'filter_widgets_imports.dart';

/// Section title followed by a wrap of choices.
class FilterSection extends StatelessWidget {
  const FilterSection({super.key, required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
        Wrap(spacing: 8, runSpacing: 8, children: children),
      ],
    );
  }
}
