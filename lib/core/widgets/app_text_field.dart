import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.keyboardType,
    this.validator,
    this.prefixIcon,
    this.maxLines = 1,
    this.inputFormatters,
    this.textDirection,
    this.onChanged,
    this.autofocus = false,
    this.textInputAction,
  });

  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final IconData? prefixIcon;
  final int maxLines;
  final List<TextInputFormatter>? inputFormatters;

  /// Use [TextDirection.ltr] for phone numbers and prices.
  final TextDirection? textDirection;
  final ValueChanged<String>? onChanged;
  final bool autofocus;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!,
              style: theme.textTheme.bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          maxLines: maxLines,
          inputFormatters: inputFormatters,
          textDirection: textDirection,
          onChanged: onChanged,
          autofocus: autofocus,
          textInputAction: textInputAction,
          style: theme.textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
          ),
        ),
      ],
    );
  }
}
