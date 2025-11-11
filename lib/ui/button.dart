import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../core/token/app_tokens.dart';

enum AppButtonVariant { primary, secondary, text, danger }

class AppButton extends StatelessWidget {
  const AppButton._({
    required this.label,
    required this.variant,
    this.onPressed,
    this.leadingIcon,
    this.backgroundColor,
    this.foregroundColor,
    this.textStyle,
    super.key,
  });

  final String label;
  final AppButtonVariant variant;
  final VoidCallback? onPressed;
  final IconData? leadingIcon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final TextStyle? textStyle;

  factory AppButton.primary({
    required String label,
    VoidCallback? onPressed,
    IconData? leadingIcon,
    Color? backgroundColor,
    Color? foregroundColor,
    TextStyle? textStyle,
    Key? key,
  }) => AppButton._(
    label: label,
    onPressed: onPressed,
    variant: AppButtonVariant.primary,
    leadingIcon: leadingIcon,
    backgroundColor: backgroundColor,
    foregroundColor: foregroundColor,
    textStyle: textStyle,
    key: key,
  );

  factory AppButton.secondary({
    required String label,
    VoidCallback? onPressed,
    IconData? leadingIcon,
    Color? backgroundColor,
    Color? foregroundColor,
    TextStyle? textStyle,
    Key? key,
  }) => AppButton._(
    label: label,
    onPressed: onPressed,
    variant: AppButtonVariant.secondary,
    leadingIcon: leadingIcon,
    backgroundColor: backgroundColor,
    foregroundColor: foregroundColor,
    textStyle: textStyle,
    key: key,
  );

  factory AppButton.text({
    required String label,
    VoidCallback? onPressed,
    IconData? leadingIcon,
    Color? foregroundColor,
    TextStyle? textStyle,
    Key? key,
  }) => AppButton._(
    label: label,
    onPressed: onPressed,
    variant: AppButtonVariant.text,
    leadingIcon: leadingIcon,
    foregroundColor: foregroundColor,
    textStyle: textStyle,
    key: key,
  );

  factory AppButton.danger({
    required String label,
    VoidCallback? onPressed,
    IconData? leadingIcon,
    Color? backgroundColor,
    Color? foregroundColor,
    TextStyle? textStyle,
    Key? key,
  }) => AppButton._(
    label: label,
    onPressed: onPressed,
    variant: AppButtonVariant.danger,
    leadingIcon: leadingIcon,
    backgroundColor: backgroundColor,
    foregroundColor: foregroundColor,
    textStyle: textStyle,
    key: key,
  );

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<AppTokens>()!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final padding = EdgeInsets.symmetric(
      horizontal: tokens.gapLarge,
      vertical: tokens.gapSmall * 0.75,
    );

    Color? effectiveBackground = backgroundColor;
    Color? effectiveForeground = foregroundColor;
    TextStyle? effectiveTextStyle = textStyle ?? textTheme.labelLarge;

    switch (variant) {
      case AppButtonVariant.primary:
        break;
      case AppButtonVariant.secondary:
        break;
      case AppButtonVariant.text:
        effectiveForeground ??= colorScheme.primary;
        break;
      case AppButtonVariant.danger:
        effectiveBackground ??= colorScheme.error;
        effectiveForeground ??= colorScheme.onError;
        break;
    }

    if (effectiveForeground != null && effectiveTextStyle != null) {
      effectiveTextStyle = effectiveTextStyle.copyWith(
        color: effectiveForeground,
      );
    }

    final icon =
        leadingIcon != null
            ? Icon(
              leadingIcon,
              size:
                  effectiveTextStyle?.fontSize ??
                  textTheme.labelLarge?.fontSize,
            )
            : null;

    Widget child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[icon, Gap(tokens.gapSmall)],
        Text(label),
      ],
    );

    if (effectiveForeground != null) {
      child = IconTheme.merge(
        data: IconThemeData(color: effectiveForeground),
        child: child,
      );
    }

    if (effectiveTextStyle != null) {
      child = DefaultTextStyle.merge(style: effectiveTextStyle, child: child);
    }

    ButtonStyle style = ButtonStyle(
      padding: WidgetStatePropertyAll(padding),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: tokens.radiusMedium),
      ),
    );

    if (effectiveBackground != null) {
      style = style.copyWith(
        backgroundColor: WidgetStatePropertyAll(effectiveBackground),
      );
    }

    if (effectiveForeground != null) {
      style = style.copyWith(
        foregroundColor: WidgetStatePropertyAll(effectiveForeground),
        iconColor: WidgetStatePropertyAll(effectiveForeground),
      );
    }

    if (effectiveTextStyle != null) {
      style = style.copyWith(
        textStyle: WidgetStatePropertyAll(effectiveTextStyle),
      );
    }

    switch (variant) {
      case AppButtonVariant.primary:
        return FilledButton(onPressed: onPressed, style: style, child: child);
      case AppButtonVariant.secondary:
        return FilledButton.tonal(
          onPressed: onPressed,
          style: style,
          child: child,
        );
      case AppButtonVariant.text:
        return TextButton(onPressed: onPressed, style: style, child: child);
      case AppButtonVariant.danger:
        return FilledButton(onPressed: onPressed, style: style, child: child);
    }
  }
}
