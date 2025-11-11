import 'package:flutter/material.dart';

import '../../core/token/app_tokens.dart';

/// 태그/칩 등을 Wrap으로 배치하는 공통 위젯.
class AppWrapTags<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(BuildContext, T, int) chipBuilder;
  final double? spacing;
  final double? runSpacing;
  final EdgeInsetsGeometry? padding;
  final WidgetBuilder? emptyBuilder;

  const AppWrapTags({
    super.key,
    required this.items,
    required this.chipBuilder,
    this.spacing,
    this.runSpacing,
    this.padding,
    this.emptyBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<AppTokens>()!;
    if (items.isEmpty) {
      return (emptyBuilder ?? (_) => const SizedBox.shrink())(context);
    }
    return SingleChildScrollView(
      padding: padding ?? EdgeInsets.all(tokens.padding),
      child: Wrap(
        spacing: spacing ?? tokens.spacing,
        runSpacing: runSpacing ?? tokens.spacing,
        children: [
          for (var i = 0; i < items.length; i++)
            chipBuilder(context, items[i], i),
        ],
      ),
    );
  }
}
