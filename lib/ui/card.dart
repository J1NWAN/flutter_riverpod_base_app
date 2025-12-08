import 'package:flutter/material.dart';

import '../../core/token/app_tokens.dart';

/// 공통 카드 컴포넌트
/// - padding/배경/마진/라운드/그림자 모두 옵션화
class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.radius,
    this.elevation,
    this.fullWidth = true,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final BorderRadiusGeometry? radius;

  /// 0을 주면 그림자 없이 평면 카드, null이면 토큰 기본값 사용
  final double? elevation;

  /// true면 width를 최대화(double.infinity), false면 자식 크기에 맞춤
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<AppTokens>()!;
    final color = backgroundColor ?? theme.colorScheme.surface;
    final cardElevation = elevation ?? tokens.cardElevation;
    final boxShadow =
        cardElevation > 0
            ? [
              BoxShadow(
                color: theme.colorScheme.shadow.withOpacity(0.08),
                blurRadius: cardElevation * 2,
                offset: Offset(0, cardElevation),
              ),
            ]
            : const <BoxShadow>[];

    return Container(
      width: fullWidth ? double.infinity : null,
      margin: margin ?? EdgeInsets.all(tokens.gapSmall),
      padding: padding ?? EdgeInsets.all(tokens.gapLarge),
      decoration: BoxDecoration(
        color: color,
        borderRadius: radius ?? tokens.radiusMedium,
        boxShadow: boxShadow,
      ),
      child: child,
    );
  }
}
