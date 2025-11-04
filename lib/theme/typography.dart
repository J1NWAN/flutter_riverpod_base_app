import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  const AppTypography._();

  static TextTheme textTheme(ColorScheme colorScheme) {
    final base = GoogleFonts.plusJakartaSansTextTheme();
    return base.apply(
      bodyColor: colorScheme.onBackground,
      displayColor: colorScheme.onBackground,
    );
  }

  static TextTheme darkTextTheme(ColorScheme colorScheme) {
    final base = GoogleFonts.plusJakartaSansTextTheme();
    return base.apply(
      bodyColor: colorScheme.onBackground,
      displayColor: colorScheme.onBackground,
    );
  }
}
