import 'package:flutter/material.dart';

import '../commons/app_text/app_text.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme_colors.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface,
      error: AppColors.error,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: AppText.textTheme(colorScheme),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
      ),
      inputDecorationTheme: AppThemeColors.inputDecoration(colorScheme),
      dropdownMenuTheme: AppThemeColors.dropdownMenuTheme(colorScheme),
      datePickerTheme: AppThemeColors.datePickerTheme(colorScheme),
      extensions: <ThemeExtension<dynamic>>[
        AppThemeColors.light(),
      ],
    );
  }

  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      primary: AppColors.primaryLight,
      secondary: AppColors.secondaryLight,
      surface: AppColors.surfaceDark,
      error: AppColors.errorLight,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      textTheme: AppText.textTheme(colorScheme),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.backgroundDark,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
      ),
      inputDecorationTheme: AppThemeColors.inputDecoration(colorScheme),
      dropdownMenuTheme: AppThemeColors.dropdownMenuTheme(colorScheme),
      datePickerTheme: AppThemeColors.datePickerTheme(colorScheme),
      extensions: <ThemeExtension<dynamic>>[
        AppThemeColors.dark(),
      ],
    );
  }
}
