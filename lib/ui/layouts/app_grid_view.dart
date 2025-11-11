import 'package:flutter/material.dart';

import '../../app/responsive/app_responsive.dart';
import '../../core/token/app_tokens.dart';

/// Breakpoint 기반 공통 GridView.
class AppGridView<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(BuildContext, T, int) itemBuilder;
  final int? crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;
  final EdgeInsetsGeometry? padding;

  const AppGridView({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.crossAxisCount,
    this.mainAxisSpacing = 12,
    this.crossAxisSpacing = 12,
    this.childAspectRatio = 3 / 4,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<AppTokens>()!;
    final cols = crossAxisCount ?? gridColumnsOf(breakpointOf(context));
    return GridView.builder(
      padding: padding ?? EdgeInsets.all(tokens.padding),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (ctx, index) => itemBuilder(ctx, items[index], index),
    );
  }
}
