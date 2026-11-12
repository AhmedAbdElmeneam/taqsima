part of 'profile_widgets_imports.dart';

/// Name field + save. Pops the trimmed name.
class EditNameSheet extends StatefulWidget {
  const EditNameSheet({super.key, required this.initialName});
  final String initialName;

  @override
  State<EditNameSheet> createState() => _EditNameSheetState();
}

class _EditNameSheetState extends State<EditNameSheet> {
  late final _name = TextEditingController(text: widget.initialName);

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(controller: _name, hint: S.fullNameHint, autofocus: true),
        const SizedBox(height: 16),
        PrimaryButton(
          label: S.save,
          onPressed: () => Navigator.pop(context, _name.text.trim()),
        ),
      ],
    );
  }
}
