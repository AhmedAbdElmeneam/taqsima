import 'package:flutter/material.dart';

import '../l10n/app_strings.dart';
import '../theme/app_colors.dart';
import 'app_button.dart';

/// Shows a rounded, keyboard-aware bottom sheet with an optional title.
Future<T?> showAppBottomSheet<T>(
  BuildContext context, {
  String? title,
  required WidgetBuilder builder,
}) {
  return showModalBottomSheet<T>(
    context: context,
    // Above the bottom navigation bar.
    useRootNavigator: true,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: MediaQuery.viewInsetsOf(ctx).bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title != null) ...[
              Text(title,
                  style: Theme.of(ctx).textTheme.titleLarge,
                  textAlign: TextAlign.center),
              const SizedBox(height: 16),
            ],
            builder(ctx),
          ],
        ),
      ),
    ),
  );
}

/// Yes/no confirmation in a bottom sheet. Returns true when confirmed.
Future<bool> showConfirmSheet(
  BuildContext context, {
  required String title,
  String? message,
  required String confirmLabel,
  String cancelLabel = S.back,
  bool destructive = false,
}) async {
  final result = await showAppBottomSheet<bool>(
    context,
    title: title,
    builder: (ctx) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (message != null) ...[
          Text(message,
              textAlign: TextAlign.center,
              style: Theme.of(ctx)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: AppColors.inkMuted)),
          const SizedBox(height: 20),
        ],
        PrimaryButton(
          label: confirmLabel,
          color: destructive ? AppColors.error : null,
          onPressed: () => Navigator.pop(ctx, true),
        ),
        const SizedBox(height: 10),
        SecondaryButton(
            label: cancelLabel, onPressed: () => Navigator.pop(ctx, false)),
      ],
    ),
  );
  return result ?? false;
}

void showSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
