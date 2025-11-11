import 'package:flutter/material.dart';

import '../../core/token/app_tokens.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    this.controller,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.obscureText = false,
    this.onChanged,
    this.maxLines = 1,
    this.errorText,
    super.key,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final int maxLines;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<AppTokens>()!;

    final border = OutlineInputBorder(
      borderRadius: tokens.radiusMedium,
      borderSide: BorderSide(color: theme.colorScheme.outlineVariant, width: 1),
    );

    final focusedBorder = OutlineInputBorder(
      borderRadius: tokens.radiusMedium,
      borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
    );

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: EdgeInsets.symmetric(
          horizontal: tokens.gapLarge,
          vertical: tokens.gapMedium,
        ),
        border: border,
        enabledBorder: border,
        focusedBorder: focusedBorder,
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.3,
        ),
        errorText: errorText,
      ),
    );
  }
}
