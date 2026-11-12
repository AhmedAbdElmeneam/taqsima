part of 'booking_requests_widgets_imports.dart';

/// Search by player name or phone.
class RequestsSearchField extends StatelessWidget {
  const RequestsSearchField({
    super.key,
    required this.controller,
    required this.searching,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final bool searching;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: TextField(
        controller: controller,
        textInputAction: TextInputAction.search,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: S.searchRequestsHint,
          prefixIcon: const Icon(AppIcons.search, size: 20),
          suffixIcon: searching
              ? IconButton(
                  icon: const Icon(AppIcons.close, size: 18),
                  onPressed: onClear,
                )
              : null,
        ),
      ),
    );
  }
}
