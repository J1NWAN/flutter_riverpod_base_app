import 'package:flutter/material.dart';

/// 앱 공통 디자인 토큰. radius/gap/breakpoint 등을 ThemeExtension으로 제공한다.
@immutable
class AppTokens extends ThemeExtension<AppTokens> {
  final BorderRadius radiusSmall;
  final BorderRadius radiusMedium;
  final BorderRadius radiusLarge;
  final double gapSmall;
  final double gapMedium;
  final double gapLarge;
  final double gapXLarge;
  final Duration fastAnimation;
  final Duration normalAnimation;
  final double breakpointTablet;
  final double breakpointDesktop;
  final double navigationRailWidth;
  final double cardElevation;

  const AppTokens({
    required this.radiusSmall,
    required this.radiusMedium,
    required this.radiusLarge,
    required this.gapSmall,
    required this.gapMedium,
    required this.gapLarge,
    required this.gapXLarge,
    required this.fastAnimation,
    required this.normalAnimation,
    required this.breakpointTablet,
    required this.breakpointDesktop,
    required this.navigationRailWidth,
    required this.cardElevation,
  });

  factory AppTokens.light() => AppTokens(
        radiusSmall: BorderRadius.circular(8),
        radiusMedium: BorderRadius.circular(16),
        radiusLarge: BorderRadius.circular(24),
        gapSmall: 8,
        gapMedium: 16,
        gapLarge: 24,
        gapXLarge: 32,
        fastAnimation: const Duration(milliseconds: 200),
        normalAnimation: const Duration(milliseconds: 400),
        breakpointTablet: 768,
        breakpointDesktop: 1024,
        navigationRailWidth: 280,
        cardElevation: 4,
      );

  factory AppTokens.dark() => AppTokens(
        radiusSmall: BorderRadius.circular(8),
        radiusMedium: BorderRadius.circular(16),
        radiusLarge: BorderRadius.circular(24),
        gapSmall: 8,
        gapMedium: 16,
        gapLarge: 24,
        gapXLarge: 32,
        fastAnimation: const Duration(milliseconds: 200),
        normalAnimation: const Duration(milliseconds: 400),
        breakpointTablet: 768,
        breakpointDesktop: 1024,
        navigationRailWidth: 280,
        cardElevation: 4,
      );

  double get padding => gapLarge;
  double get spacing => gapMedium;

  @override
  AppTokens copyWith({
    BorderRadius? radiusSmall,
    BorderRadius? radiusMedium,
    BorderRadius? radiusLarge,
    double? gapSmall,
    double? gapMedium,
    double? gapLarge,
    double? gapXLarge,
    Duration? fastAnimation,
    Duration? normalAnimation,
    double? breakpointTablet,
    double? breakpointDesktop,
    double? navigationRailWidth,
    double? cardElevation,
  }) {
    return AppTokens(
      radiusSmall: radiusSmall ?? this.radiusSmall,
      radiusMedium: radiusMedium ?? this.radiusMedium,
      radiusLarge: radiusLarge ?? this.radiusLarge,
      gapSmall: gapSmall ?? this.gapSmall,
      gapMedium: gapMedium ?? this.gapMedium,
      gapLarge: gapLarge ?? this.gapLarge,
      gapXLarge: gapXLarge ?? this.gapXLarge,
      fastAnimation: fastAnimation ?? this.fastAnimation,
      normalAnimation: normalAnimation ?? this.normalAnimation,
      breakpointTablet: breakpointTablet ?? this.breakpointTablet,
      breakpointDesktop: breakpointDesktop ?? this.breakpointDesktop,
      navigationRailWidth: navigationRailWidth ?? this.navigationRailWidth,
      cardElevation: cardElevation ?? this.cardElevation,
    );
  }

  @override
  AppTokens lerp(ThemeExtension<AppTokens>? other, double t) {
    if (other is! AppTokens) return this;
    return AppTokens(
      radiusSmall: BorderRadius.lerp(radiusSmall, other.radiusSmall, t)!,
      radiusMedium: BorderRadius.lerp(radiusMedium, other.radiusMedium, t)!,
      radiusLarge: BorderRadius.lerp(radiusLarge, other.radiusLarge, t)!,
      gapSmall: _lerpDouble(gapSmall, other.gapSmall, t),
      gapMedium: _lerpDouble(gapMedium, other.gapMedium, t),
      gapLarge: _lerpDouble(gapLarge, other.gapLarge, t),
      gapXLarge: _lerpDouble(gapXLarge, other.gapXLarge, t),
      fastAnimation: _lerpDuration(fastAnimation, other.fastAnimation, t),
      normalAnimation: _lerpDuration(normalAnimation, other.normalAnimation, t),
      breakpointTablet: _lerpDouble(breakpointTablet, other.breakpointTablet, t),
      breakpointDesktop:
          _lerpDouble(breakpointDesktop, other.breakpointDesktop, t),
      navigationRailWidth:
          _lerpDouble(navigationRailWidth, other.navigationRailWidth, t),
      cardElevation: _lerpDouble(cardElevation, other.cardElevation, t),
    );
  }

  static double _lerpDouble(double a, double b, double t) =>
      a + (b - a) * t;

  static Duration _lerpDuration(Duration a, Duration b, double t) {
    return Duration(
      milliseconds: (a.inMilliseconds +
              (b.inMilliseconds - a.inMilliseconds) * t)
          .round(),
    );
  }
}
