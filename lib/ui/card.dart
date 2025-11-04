import 'package:flutter/material.dart';

import '../theme/tokens.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.padding,
    this.margin,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<AppTokens>()!;
    final background = theme.colorScheme.surface;
    final elevation = tokens.cardElevation;

    return Container(
      margin: margin ?? EdgeInsets.all(tokens.gapSmall),
      padding: padding ?? EdgeInsets.all(tokens.gapLarge),
      decoration: BoxDecoration(
        color: background,
        borderRadius: tokens.radiusLarge,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.08),
            blurRadius: elevation * 2,
            offset: Offset(0, elevation),
          ),
        ],
      ),
      child: child,
    );
  }
}
