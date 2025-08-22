import 'package:flutter/material.dart';

// 🎨 Color Palette - Modern Design System
const primaryColor = Color(0xff6366F1); // Indigo-500
const primaryLightColor = Color(0xff818CF8); // Indigo-400
const primaryDarkColor = Color(0xff4F46E5); // Indigo-600

const secondaryColor = Color(0xff8B5CF6); // Violet-500
const secondaryLightColor = Color(0xffA78BFA); // Violet-400
const secondaryDarkColor = Color(0xff7C3AED); // Violet-600

const accentColor = Color(0xffffffff); // White
const backgroundColor = Color(0xffF8FAFC); // Slate-50
const surfaceColor = Color(0xffF1F5F9); // Slate-100
const cardColor = Color(0xffffffff); // White

// Text Colors
const textPrimaryColor = Color(0xff0F172A); // Slate-900
const textSecondaryColor = Color(0xff475569); // Slate-600
const textMutedColor = Color(0xff94A3B8); // Slate-400

// Status Colors
const successColor = Color(0xff10B981); // Emerald-500
const warningColor = Color(0xffF59E0B); // Amber-500
const errorColor = Color(0xffEF4444); // Red-500
const infoColor = Color(0xff3B82F6); // Blue-500

// Border Colors
const borderColor = Color(0xffE2E8F0); // Slate-200
const borderFocusColor = Color(0xff6366F1); // Primary
const borderErrorColor = Color(0xffEF4444); // Error

// 📏 Spacing System
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

// 🎭 Border Radius
class AppRadius {
  static const double sm = 6.0;
  static const double md = 8.0;
  static const double lg = 12.0;
  static const double xl = 16.0;
  static const double xxl = 24.0;
  static const double full = 9999.0;
}

// 📝 Typography Scale
class AppTextStyles {
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
    height: 1.2,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
    height: 1.3,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textPrimaryColor,
    height: 1.4,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: textPrimaryColor,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textSecondaryColor,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: textMutedColor,
    height: 1.4,
  );

  static const TextStyle label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: textSecondaryColor,
    height: 1.4,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: textMutedColor,
    height: 1.3,
  );
}

// 🎯 Button Styles
class AppButtonStyles {
  static ButtonStyle primary = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    elevation: 2,
    shadowColor: primaryColor.withOpacity(0.3),
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.md,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
    ),
    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  );

  static ButtonStyle secondary = ElevatedButton.styleFrom(
    backgroundColor: surfaceColor,
    foregroundColor: textPrimaryColor,
    elevation: 1,
    shadowColor: Colors.black.withOpacity(0.1),
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.md,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      side: const BorderSide(color: borderColor, width: 1),
    ),
    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  );
}

// 📦 Card Styles
class AppCardDecoration {
  static BoxDecoration elevated = BoxDecoration(
    color: cardColor,
    borderRadius: BorderRadius.circular(AppRadius.xl),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.04),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
      BoxShadow(
        color: Colors.black.withOpacity(0.02),
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static BoxDecoration outlined = BoxDecoration(
    color: cardColor,
    borderRadius: BorderRadius.circular(AppRadius.xl),
    border: Border.all(color: borderColor, width: 1),
  );
}

// 🎨 Gradient Definitions
class AppGradients {
  static const LinearGradient primary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryColor, secondaryColor],
  );

  static const LinearGradient surface = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [backgroundColor, surfaceColor],
  );

  static const LinearGradient shimmer = LinearGradient(
    colors: [Color(0xffF1F5F9), Color(0xffE2E8F0), Color(0xffF1F5F9)],
  );
}
