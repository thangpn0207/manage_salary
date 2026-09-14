import 'package:flutter/material.dart';
import 'package:manage_salary/core/constants/colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.onSecondaryContainer,
        error: AppColors.error,
        onError: AppColors.onError,
        errorContainer: AppColors.errorContainer,
        onErrorContainer: AppColors.onErrorContainer,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        surfaceContainerHighest: AppColors.surfaceVariant,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
        shadow: AppColors.shadow,
        scrim: AppColors.scrim,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.outline),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.bold),
        headlineLarge:
            TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.bold),
        headlineMedium:
            TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.bold),
        headlineSmall:
            TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w600),
        titleSmall: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: AppColors.onSurface),
        bodyMedium: TextStyle(color: AppColors.onSurface),
        bodySmall: TextStyle(color: AppColors.onSurfaceVariant),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color>(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primary;
            }
            return Colors.grey.shade400;
          },
        ),
        trackColor: WidgetStateProperty.resolveWith<Color>(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primary.withValues(alpha: 0.35);
            }
            return Colors.grey.withValues(alpha: 0.2);
          },
        ),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.outline,
        thickness: 1,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.primaryContainer,
        onPrimary: AppColors.darkBackground,
        primaryContainer: AppColors.primary.withValues(alpha: 0.3),
        onPrimaryContainer: Colors.white,
        secondary: AppColors.secondary,
        onSecondary: Colors.black,
        secondaryContainer: AppColors.secondary.withValues(alpha: 0.2),
        onSecondaryContainer: Colors.amber.shade200,
        error: AppColors.error,
        onError: AppColors.onError,
        errorContainer: AppColors.errorContainer.withValues(alpha: 0.2),
        onErrorContainer: AppColors.onErrorContainer,
        surface: AppColors.darkSurface,
        onSurface: Colors.white,
        surfaceContainerHighest: AppColors.darkSurfaceContainer,
        onSurfaceVariant: const Color(0xFF94A3B8),
        outline: AppColors.darkOutline,
        outlineVariant: AppColors.darkOutline.withValues(alpha: 0.5),
        shadow: AppColors.shadow,
        scrim: AppColors.scrim,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.darkOutline),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryContainer,
          foregroundColor: AppColors.darkBackground,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryContainer,
          side: const BorderSide(color: AppColors.darkOutline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryContainer,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurfaceContainer,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.darkOutline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryContainer, width: 1.5),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.darkOutline,
        thickness: 1,
      ),
    );
  }
}
