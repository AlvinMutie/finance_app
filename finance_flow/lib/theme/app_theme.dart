import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Backgrounds
  static const Color background = Color(0xFF131313);
  static const Color surface = Color(0xFF121212);
  static const Color surfaceDim = Color(0xFF131313);
  static const Color surfaceContainerLowest = Color(0xFF0E0E0E);
  static const Color surfaceContainerLow = Color(0xFF1C1B1B);
  static const Color surfaceContainer = Color(0xFF201F1F);
  static const Color surfaceContainerHigh = Color(0xFF2A2A2A);
  static const Color surfaceContainerHighest = Color(0xFF353534);
  static const Color surfaceBright = Color(0xFF3A3939);
  static const Color surfaceVariant = Color(0xFF353534);

  // Text
  static const Color onSurface = Color(0xFFE5E2E1);
  static const Color onSurfaceVariant = Color(0xFFC9C4D8);
  static const Color onBackground = Color(0xFFE5E2E1);

  // Borders
  static const Color outline = Color(0xFF938EA1);
  static const Color outlineVariant = Color(0xFF484555);
  static const Color cardBorder = Color(0xFF262626);

  // Primary — Vibrant Purple
  static const Color primary = Color(0xFFCABEFF);
  static const Color primaryContainer = Color(0xFF947DFF);
  static const Color inversePrimary = Color(0xFF603CE2);
  static const Color onPrimary = Color(0xFF31009A);

  // Secondary — Neon Blue
  static const Color secondary = Color(0xFF7BD0FF);
  static const Color secondaryContainer = Color(0xFF00A6E0);
  static const Color onSecondary = Color(0xFF00354A);

  // Tertiary — Lime Green
  static const Color tertiary = Color(0xFF98DA27);
  static const Color tertiaryContainer = Color(0xFF6BA000);
  static const Color onTertiary = Color(0xFF213600);

  // Error — Coral
  static const Color error = Color(0xFFFFB4AB);
  static const Color errorContainer = Color(0xFF93000A);

  // Semantic
  static const Color income = Color(0xFF98DA27);
  static const Color expense = Color(0xFFFFB4AB);
  static const Color transfer = Color(0xFF7BD0FF);
}

class AppTextStyles {
  static TextStyle displayLg = GoogleFonts.manrope(
    fontSize: 48, fontWeight: FontWeight.w800,
    letterSpacing: -0.04 * 48, color: AppColors.onSurface,
  );
  static TextStyle headlineLg = GoogleFonts.manrope(
    fontSize: 32, fontWeight: FontWeight.w700,
    letterSpacing: -0.02 * 32, color: AppColors.onSurface,
  );
  static TextStyle headlineLgMobile = GoogleFonts.manrope(
    fontSize: 28, fontWeight: FontWeight.w700,
    letterSpacing: -0.02 * 28, color: AppColors.onSurface,
  );
  static TextStyle headlineMd = GoogleFonts.manrope(
    fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.onSurface,
  );
  static TextStyle bodyLg = GoogleFonts.manrope(
    fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.onSurface,
  );
  static TextStyle bodyMd = GoogleFonts.manrope(
    fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.onSurface,
  );
  static TextStyle labelMd = GoogleFonts.manrope(
    fontSize: 14, fontWeight: FontWeight.w600,
    letterSpacing: 0.05 * 14, color: AppColors.outline,
  );
  static TextStyle labelSm = GoogleFonts.manrope(
    fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.outline,
  );
}

class AppTheme {
  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.tertiary,
        error: AppColors.error,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        outline: AppColors.outline,
      ),
      textTheme: GoogleFonts.manropeTextTheme(ThemeData.dark().textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background.withOpacity(0.8),
        elevation: 0,
        titleTextStyle: GoogleFonts.manrope(
          fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.primary,
        ),
        iconTheme: const IconThemeData(color: AppColors.onSurfaceVariant),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.outline,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}
