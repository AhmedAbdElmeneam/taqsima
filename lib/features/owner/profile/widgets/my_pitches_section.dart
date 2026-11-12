part of 'owner_profile_widgets_imports.dart';

/// "My pitches" header with "add pitch", then [child] (the cards).
class MyPitchesSection extends StatelessWidget {
  const MyPitchesSection({super.key, required this.onAdd, required this.child});

  final VoidCallback onAdd;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(title: S.myPitches, action: S.addPitch, onAction: onAdd),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}
