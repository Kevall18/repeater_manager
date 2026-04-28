import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppThemeColors extends ThemeExtension<AppThemeColors> {
  const AppThemeColors({
    required this.card,
    required this.border,
    required this.subtitle,
    required this.success,
    required this.warning,
    required this.info,
  });

  final Color card;
  final Color border;
  final Color subtitle;
  final Color success;
  final Color warning;
  final Color info;

  static AppThemeColors light() {
    return const AppThemeColors(
      card: AppColors.surface,
      border: AppColors.border,
      subtitle: AppColors.textSecondary,
      success: AppColors.success,
      warning: AppColors.warning,
      info: AppColors.info,
    );
  }

  static AppThemeColors dark() {
    return const AppThemeColors(
      card: AppColors.surfaceDark,
      border: AppColors.borderDark,
      subtitle: AppColors.textSecondaryDark,
      success: AppColors.success,
      warning: AppColors.warning,
      info: AppColors.info,
    );
  }

  static InputDecorationTheme inputDecoration(ColorScheme colorScheme) {
    return InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colorScheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colorScheme.error, width: 1.5),
      ),
      hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
    );
  }

  static DropdownMenuThemeData dropdownMenuTheme(ColorScheme colorScheme) {
    return DropdownMenuThemeData(
      inputDecorationTheme: inputDecoration(colorScheme),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(colorScheme.surface),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      textStyle: TextStyle(color: colorScheme.onSurface),
    );
  }

  static DatePickerThemeData datePickerTheme(ColorScheme colorScheme) {
    return DatePickerThemeData(
      backgroundColor: colorScheme.surface,
      headerBackgroundColor: colorScheme.primary,
      headerForegroundColor: colorScheme.onPrimary,
      dayForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.onPrimary;
        }
        return colorScheme.onSurface;
      }),
      dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary;
        }
        return null;
      }),
      todayForegroundColor: WidgetStatePropertyAll(colorScheme.primary),
      todayBackgroundColor:
          WidgetStatePropertyAll(colorScheme.primary.withValues(alpha: 0.12)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  @override
  AppThemeColors copyWith({
    Color? card,
    Color? border,
    Color? subtitle,
    Color? success,
    Color? warning,
    Color? info,
  }) {
    return AppThemeColors(
      card: card ?? this.card,
      border: border ?? this.border,
      subtitle: subtitle ?? this.subtitle,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
    );
  }

  @override
  AppThemeColors lerp(ThemeExtension<AppThemeColors>? other, double t) {
    if (other is! AppThemeColors) {
      return this;
    }

    return AppThemeColors(
      card: Color.lerp(card, other.card, t) ?? card,
      border: Color.lerp(border, other.border, t) ?? border,
      subtitle: Color.lerp(subtitle, other.subtitle, t) ?? subtitle,
      success: Color.lerp(success, other.success, t) ?? success,
      warning: Color.lerp(warning, other.warning, t) ?? warning,
      info: Color.lerp(info, other.info, t) ?? info,
    );
  }
}
