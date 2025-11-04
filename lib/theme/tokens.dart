import 'package:flutter/material.dart';

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
  AppTokens lerp(AppTokens? other, double t) {
    if (other == null) {
      return this;
    }
    return AppTokens(
      radiusSmall: BorderRadius.lerp(radiusSmall, other.radiusSmall, t)!,
      radiusMedium: BorderRadius.lerp(radiusMedium, other.radiusMedium, t)!,
      radiusLarge: BorderRadius.lerp(radiusLarge, other.radiusLarge, t)!,
      gapSmall: gapSmall + (other.gapSmall - gapSmall) * t,
      gapMedium: gapMedium + (other.gapMedium - gapMedium) * t,
      gapLarge: gapLarge + (other.gapLarge - gapLarge) * t,
      gapXLarge: gapXLarge + (other.gapXLarge - gapXLarge) * t,
      fastAnimation: Duration(
        milliseconds: (fastAnimation.inMilliseconds +
                (other.fastAnimation.inMilliseconds -
                        fastAnimation.inMilliseconds) *
                    t)
            .round(),
      ),
      normalAnimation: Duration(
        milliseconds: (normalAnimation.inMilliseconds +
                (other.normalAnimation.inMilliseconds -
                        normalAnimation.inMilliseconds) *
                    t)
            .round(),
      ),
      breakpointTablet: breakpointTablet +
          (other.breakpointTablet - breakpointTablet) * t,
      breakpointDesktop: breakpointDesktop +
          (other.breakpointDesktop - breakpointDesktop) * t,
      navigationRailWidth: navigationRailWidth +
          (other.navigationRailWidth - navigationRailWidth) * t,
      cardElevation:
          cardElevation + (other.cardElevation - cardElevation) * t,
    );
  }
}
