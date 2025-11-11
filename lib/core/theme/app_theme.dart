import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import '../token/app_tokens.dart';

/// FlexColorScheme 기반으로 라이트/다크 테마를 구성한다.
class AppTheme {
  const AppTheme._();

  /// 라이트 테마. [seed] 색상으로 ColorScheme 생성.
  static ThemeData light(Color seed) {
    final scheme = FlexThemeData.light(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seed,
        brightness: Brightness.light,
      ),
    );
    return scheme.copyWith(
      extensions: <ThemeExtension<dynamic>>[AppTokens.light()],
    );
  }

  /// 다크 테마. [seed] 색상으로 ColorScheme 생성.
  static ThemeData dark(Color seed) {
    final scheme = FlexThemeData.dark(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seed,
        brightness: Brightness.dark,
      ),
    );
    return scheme.copyWith(
      extensions: <ThemeExtension<dynamic>>[AppTokens.dark()],
    );
  }
}
