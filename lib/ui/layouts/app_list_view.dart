import 'package:flutter/material.dart';

import '../../core/token/app_tokens.dart';

/// 토큰 기반 ListView. 비어있을 때 placeholder 출력 가능.
class AppListView<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(BuildContext, T, int) itemBuilder;
  final EdgeInsetsGeometry? padding;
  final double? spacing;
  final WidgetBuilder? emptyBuilder;

  const AppListView({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.padding,
    this.spacing,
    this.emptyBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<AppTokens>()!;
    if (items.isEmpty) {
      return (emptyBuilder ?? (_) => const SizedBox.shrink())(context);
    }
    return ListView.separated(
      padding: padding ?? EdgeInsets.all(tokens.padding),
      itemCount: items.length,
      separatorBuilder: (_, __) => SizedBox(height: spacing ?? tokens.spacing),
      itemBuilder: (ctx, index) => itemBuilder(ctx, items[index], index),
    );
  }
}
