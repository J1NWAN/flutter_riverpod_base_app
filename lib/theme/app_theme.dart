import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import 'tokens.dart';
import 'typography.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    final base = FlexThemeData.light(
      colors: const FlexSchemeColor(
        primary: Color(0xFF4A6572),
        primaryContainer: Color(0xFF96A7AF),
        secondary: Color(0xFF1B998B),
        secondaryContainer: Color(0xFFA9E5BB),
        tertiary: Color(0xFFEDAE49),
        tertiaryContainer: Color(0xFFFFDC9C),
        error: Color(0xFFD64550),
      ),
      useMaterial3: true,
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 10,
      subThemesData: const FlexSubThemesData(
        blendOnLevel: 12,
        useTextTheme: true,
        alignedDropdown: true,
        inputDecoratorBorderType: FlexInputBorderType.outline,
        inputDecoratorIsFilled: true,
        navigationBarHeight: 64,
      ),
      visualDensity: VisualDensity.standard,
    );
    return base.copyWith(
      textTheme: AppTypography.textTheme(base.colorScheme),
      extensions: <ThemeExtension<dynamic>>[
        AppTokens.light(),
      ],
    );
  }

  static ThemeData dark() {
    final base = FlexThemeData.dark(
      colors: const FlexSchemeColor(
        primary: Color(0xFF8AA5B1),
        primaryContainer: Color(0xFF4A6572),
        secondary: Color(0xFF4BC9B6),
        secondaryContainer: Color(0xFF1B998B),
        tertiary: Color(0xFFE9B872),
        tertiaryContainer: Color(0xFFEDAE49),
        error: Color(0xFFEF5D60),
      ),
      useMaterial3: true,
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 15,
      subThemesData: const FlexSubThemesData(
        blendOnLevel: 18,
        useTextTheme: true,
        alignedDropdown: true,
        inputDecoratorBorderType: FlexInputBorderType.outline,
        inputDecoratorIsFilled: true,
        navigationBarHeight: 64,
      ),
      visualDensity: VisualDensity.standard,
    );
    return base.copyWith(
      textTheme: AppTypography.darkTextTheme(base.colorScheme),
      extensions: <ThemeExtension<dynamic>>[
        AppTokens.dark(),
      ],
    );
  }
}
