part of 'player_booking_details_widgets_imports.dart';

/// Text box + send. Pops `true` when sent.
class ReportProblemSheet extends StatefulWidget {
  const ReportProblemSheet({super.key});

  @override
  State<ReportProblemSheet> createState() => _ReportProblemSheetState();
}

class _ReportProblemSheetState extends State<ReportProblemSheet> {
  final _text = TextEditingController();

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          controller: _text,
          hint: S.reportProblemHint,
          maxLines: 4,
          autofocus: true,
        ),
        const SizedBox(height: 16),
        PrimaryButton(
          label: S.send,
          icon: AppIcons.send,
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    );
  }
}
