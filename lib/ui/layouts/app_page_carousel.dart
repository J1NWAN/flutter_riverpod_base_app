import 'package:flutter/material.dart';

import '../../core/token/app_tokens.dart';

/// PageView 기반 공통 캐러셀 위젯.
class AppPageCarousel<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(BuildContext, T, int) pageBuilder;
  final double viewportFraction;
  final EdgeInsetsGeometry? padding;

  const AppPageCarousel({
    super.key,
    required this.items,
    required this.pageBuilder,
    this.viewportFraction = 0.9,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<AppTokens>()!;
    final controller = PageController(viewportFraction: viewportFraction);
    return PageView.builder(
      controller: controller,
      itemCount: items.length,
      itemBuilder:
          (ctx, index) => Padding(
            padding:
                padding ??
                EdgeInsets.symmetric(
                  horizontal: tokens.spacing,
                  vertical: tokens.padding,
                ),
            child: pageBuilder(ctx, items[index], index),
          ),
    );
  }
}
