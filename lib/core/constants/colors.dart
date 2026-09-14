import 'package:flutter/material.dart';

class AppColors {
  // Nordic Minimalist primary & accent colors
  static const Color primary = Color(0xFF0F766E); // Refined Nordic Pine / Deep Teal
  static const Color primaryContainer = Color(0xFF14B8A6); // Fresh Teal
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFF134E4A);

  // Secondary accents (Warm Amber & Slate Navy)
  static const Color secondary = Color(0xFFF59E0B); // Nordic Warm Amber
  static const Color secondaryContainer = Color(0xFFFEF3C7);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFF78350F);

  // Background and surface colors (Light mode)
  static const Color background = Color(0xFFF8FAFC); // Clean Slate-50 off-white
  static const Color onBackground = Color(0xFF0F172A); // Slate-900 high contrast text
  static const Color surface = Color(0xFFFFFFFF); // Pure white card surface
  static const Color onSurface = Color(0xFF0F172A);

  // Surface variant colors
  static const Color surfaceVariant = Color(0xFFF1F5F9); // Slate-100
  static const Color onSurfaceVariant = Color(0xFF475569); // Slate-600

  // Error & Warning colors
  static const Color error = Color(0xFFEF4444); // Modern Red
  static const Color errorContainer = Color(0xFFFEE2E2);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onErrorContainer = Color(0xFF7F1D1D);

  // Outline colors
  static const Color outline = Color(0xFFE2E8F0); // Subtle Slate-200 border
  static const Color outlineVariant = Color(0xFFCBD5E1);

  // Shadow color
  static const Color shadow = Color(0x0F000000);
  static const Color scrim = Color(0x66000000);

  // Cashflow & Status Accents
  static const Color upGreen = Color(0xFF10B981); // Emerald Green (Income/Surplus)
  static const Color downRed = Color(0xFFEF4444); // Rose Red (Expense/Deficit)
  static const Color inactiveGray = Color(0xFF94A3B8); // Slate-400

  // Dark theme specific surfaces (Nordic Dark Obsidian)
  static const Color darkBackground = Color(0xFF0B0F19); // Midnight Obsidian
  static const Color darkSurface = Color(0xFF131C2E); // Deep Slate Navy
  static const Color darkSurfaceContainer = Color(0xFF1E293B); // Slate-800
  static const Color darkOutline = Color(0xFF334155); // Slate-700

  // Trading / Dashboard chart colors
  static const Color chartGreen = Color(0xFF10B981);
  static const Color chartRed = Color(0xFFEF4444);
  static const Color chartAmber = Color(0xFFF59E0B);
  static const Color chartBlue = Color(0xFF3B82F6);
  static const Color chartPurple = Color(0xFF8B5CF6);

  // Semantic convenience aliases
  static const Color accent = secondary; // Amber accent
  static const Color income = upGreen; // Emerald income
  static const Color expense = downRed; // Rose expense
  static const Color textPrimary = onBackground; // Dark text on light
  static const Color textSecondary = onSurfaceVariant; // Muted text on light
  static const Color darkTextPrimary = Color(0xFFF1F5F9); // Light text on dark (Slate-100)
  static const Color darkTextSecondary = Color(0xFF94A3B8); // Muted text on dark (Slate-400)

  // Shadow colors
  static const Color shadowLight = Color(0x0A000000);
}
