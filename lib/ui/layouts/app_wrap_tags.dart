import 'package:flutter/material.dart';

import '../../core/token/app_tokens.dart';

/// 태그/칩 등을 스크롤 가능한 리스트로 보여주는 공통 위젯.
/// [scrollDirection]을 통해 가로/세로 스크롤 방식을 선택할 수 있다.
class AppWrapTags<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(BuildContext, T, int) chipBuilder;
  final double? spacing;
  final double? runSpacing;
  final EdgeInsetsGeometry? padding;
  final WidgetBuilder? emptyBuilder;
  final Axis scrollDirection;

  const AppWrapTags({
    super.key,
    required this.items,
    required this.chipBuilder,
    this.spacing,
    this.runSpacing,
    this.padding,
    this.emptyBuilder,
    this.scrollDirection = Axis.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<AppTokens>()!;
    if (items.isEmpty) {
      return (emptyBuilder ?? (_) => const SizedBox.shrink())(context);
    }

    final gap = spacing ?? tokens.spacing;
    if (scrollDirection == Axis.horizontal) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (var i = 0; i < items.length; i++) ...[
              chipBuilder(context, items[i], i),
              if (i < items.length - 1) SizedBox(width: gap),
            ],
          ],
        ),
      );
    }

    final crossGap = runSpacing ?? tokens.spacing;
    return SingleChildScrollView(
      padding: padding ?? EdgeInsets.all(tokens.padding),
      child: Wrap(
        spacing: gap,
        runSpacing: crossGap,
        children: [
          for (var i = 0; i < items.length; i++)
            chipBuilder(context, items[i], i),
        ],
      ),
    );
  }
}
