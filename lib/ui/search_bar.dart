import 'package:flutter/material.dart';

import '../core/token/app_tokens.dart';

/// 공통 검색 바 UI 컴포넌트.
class AppSearchBar extends StatelessWidget {
  const AppSearchBar({
    super.key,
    this.controller,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.leading,
    this.trailing,
    this.enabled = true,
    this.autofocus = false,
    this.padding,
    this.spacing = 4,
  });

  final TextEditingController? controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final Widget? leading;
  final Widget? trailing;
  final bool enabled;
  final bool autofocus;
  final EdgeInsetsGeometry? padding;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<AppTokens>()!;

    return Container(
      height: 35,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: tokens.radiusSmall,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: tokens.gapLarge,
            offset: Offset(0, tokens.gapSmall),
          ),
        ],
      ),
      padding: padding ?? EdgeInsets.symmetric(horizontal: tokens.gapSmall),
      child: Row(
        children: [
          leading ??
              Icon(Icons.search, color: theme.colorScheme.onSurfaceVariant),
          SizedBox(width: spacing),
          Expanded(
            child: TextField(
              controller: controller,
              enabled: enabled,
              autofocus: autofocus,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              style: theme.textTheme.bodyMedium,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(bottom: 10),
                hintText: hintText ?? '검색어를 입력하세요.',
                border: InputBorder.none,
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
