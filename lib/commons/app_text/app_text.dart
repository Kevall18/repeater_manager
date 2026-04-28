import 'package:flutter/material.dart';

class AppText {
  const AppText._();

  static const String fontFamily = 'Roboto';

  static TextTheme textTheme(ColorScheme colorScheme) {
    return TextTheme(
      displayLarge: _style(colorScheme.onSurface,
          fontSize: 57, fontWeight: FontWeight.w600),
      displayMedium: _style(colorScheme.onSurface,
          fontSize: 45, fontWeight: FontWeight.w600),
      displaySmall: _style(colorScheme.onSurface,
          fontSize: 36, fontWeight: FontWeight.w600),
      headlineLarge: _style(colorScheme.onSurface,
          fontSize: 32, fontWeight: FontWeight.w600),
      headlineMedium: _style(colorScheme.onSurface,
          fontSize: 28, fontWeight: FontWeight.w600),
      headlineSmall: _style(colorScheme.onSurface,
          fontSize: 24, fontWeight: FontWeight.w600),
      titleLarge: _style(colorScheme.onSurface,
          fontSize: 22, fontWeight: FontWeight.w600),
      titleMedium: _style(colorScheme.onSurface,
          fontSize: 16, fontWeight: FontWeight.w600),
      titleSmall: _style(colorScheme.onSurfaceVariant,
          fontSize: 14, fontWeight: FontWeight.w600),
      bodyLarge: _style(colorScheme.onSurface, fontSize: 16),
      bodyMedium: _style(colorScheme.onSurfaceVariant, fontSize: 14),
      bodySmall: _style(colorScheme.onSurfaceVariant, fontSize: 12),
      labelLarge: _style(colorScheme.onSurface,
          fontSize: 14, fontWeight: FontWeight.w600),
      labelMedium: _style(colorScheme.onSurfaceVariant,
          fontSize: 12, fontWeight: FontWeight.w600),
      labelSmall: _style(colorScheme.onSurfaceVariant,
          fontSize: 11, fontWeight: FontWeight.w600),
    );
  }

  static TextStyle headingLarge({Color? color}) {
    return _style(color ?? Colors.black,
        fontSize: 32, fontWeight: FontWeight.w600);
  }

  static TextStyle titleMedium({Color? color}) {
    return _style(color ?? Colors.black,
        fontSize: 16, fontWeight: FontWeight.w600);
  }

  static TextStyle titleLarge({Color? color}) {
    return _style(color ?? Colors.black,
        fontSize: 20, fontWeight: FontWeight.w700);
  }

  static TextStyle bodyMedium({Color? color}) {
    return _style(color ?? Colors.black, fontSize: 14);
  }

  static TextStyle labelMedium({Color? color}) {
    return _style(color ?? Colors.black,
        fontSize: 12, fontWeight: FontWeight.w600);
  }

  static TextStyle _style(
    Color color, {
    required double fontSize,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: 1.3,
      fontFamily: fontFamily,
    );
  }
}
