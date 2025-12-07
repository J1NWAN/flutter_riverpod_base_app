import 'package:flutter/material.dart';

class AppBox extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? background;

  const AppBox({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.background,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity, // 가로 최대
      padding: padding,
      decoration: BoxDecoration(
        color: background ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16), // 라운드
      ),
      child: child, // 자식에 따라 높이 결정
    );
  }
}
