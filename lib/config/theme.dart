import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFF13EC13);
  static const Color primaryDark = Color(0xFF0FB80F);
  static const Color backgroundLight = Color(0xFFF6F8F6);
  static const Color backgroundDark = Color(0xFF102210);
  static const Color surfaceDark = Color(0xFF1A2C1A);
  static const Color surfaceBorder = Color(0xFF283928);
  static const Color textPrimary = Color(0xFF111811);
  static const Color textSecondary = Color(0xFF9DB99D);
  static const Color borderLight = Color(0xFFE5E7EB);

  static const Color errorRed = Color(0xFFEF4444);
  static const Color successGreen = Color(0xFF22C55E);
  static const Color warningOrange = Color(0xFFF59E0B);
  static const Color infoBlue = Color(0xFF3B82F6);

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: backgroundLight,

    colorScheme: const ColorScheme.light(
      primary: primary,
      secondary: primary,
      error: errorRed,
      surface: Colors.white,
      background: backgroundLight,
      onPrimary: Color(0xFF111811),
      onSecondary: Color(0xFF111811),
      onBackground: Color(0xFF111811),
      onSurface: Color(0xFF111811),
    ),

    textTheme: GoogleFonts.spaceGroteskTextTheme().copyWith(
      displayLarge: GoogleFonts.spaceGrotesk(
        fontSize: 48,
        fontWeight: FontWeight.w900,
        letterSpacing: -1.5,
        color: const Color(0xFF111811),
      ),
      displayMedium: GoogleFonts.spaceGrotesk(
        fontSize: 40,
        fontWeight: FontWeight.w900,
        letterSpacing: -0.5,
        color: const Color(0xFF111811),
      ),
      displaySmall: GoogleFonts.spaceGrotesk(
        fontSize: 32,
        fontWeight: FontWeight.w900,
        color: const Color(0xFF111811),
      ),
      headlineLarge: GoogleFonts.spaceGrotesk(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF111811),
      ),
      headlineMedium: GoogleFonts.spaceGrotesk(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF111811),
      ),
      titleLarge: GoogleFonts.spaceGrotesk(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF111811),
      ),
      titleMedium: GoogleFonts.notoSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF111811),
      ),
      bodyLarge: GoogleFonts.notoSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF111811),
      ),
      bodyMedium: GoogleFonts.notoSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF111811),
      ),
      bodySmall: GoogleFonts.notoSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF6B7280),
      ),
    ),

    // AppBar Theme
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: Colors.white,
      foregroundColor: const Color(0xFF111811),
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.spaceGrotesk(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF111811),
      ),
      iconTheme: const IconThemeData(
        color: Color(0xFF111811),
      ),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: borderLight),
      ),
      color: Colors.white,
      margin: EdgeInsets.zero,
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: const Color(0xFF111811),
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: GoogleFonts.spaceGrotesk(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    ),

    // Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF111811),
        side: const BorderSide(color: Color(0xFFE5E7EB)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: GoogleFonts.spaceGrotesk(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF0F4F0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: errorRed, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: GoogleFonts.notoSans(
        fontSize: 14,
        color: const Color(0xFF9CA3AF),
      ),
    ),

    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: borderLight,
      thickness: 1,
      space: 1,
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: backgroundDark,

    colorScheme: const ColorScheme.dark(
      primary: primary,
      secondary: primary,
      error: errorRed,
      surface: surfaceDark,
      background: backgroundDark,
      onPrimary: backgroundDark,
      onSecondary: backgroundDark,
      onBackground: Colors.white,
      onSurface: Colors.white,
    ),

    // Typography
    textTheme: GoogleFonts.spaceGroteskTextTheme(ThemeData.dark().textTheme).copyWith(
      displayLarge: GoogleFonts.spaceGrotesk(
        fontSize: 48,
        fontWeight: FontWeight.w900,
        letterSpacing: -1.5,
        color: Colors.white,
      ),
      displayMedium: GoogleFonts.spaceGrotesk(
        fontSize: 40,
        fontWeight: FontWeight.w900,
        letterSpacing: -0.5,
        color: Colors.white,
      ),
      displaySmall: GoogleFonts.spaceGrotesk(
        fontSize: 32,
        fontWeight: FontWeight.w900,
        color: Colors.white,
      ),
      headlineLarge: GoogleFonts.spaceGrotesk(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      headlineMedium: GoogleFonts.spaceGrotesk(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      titleLarge: GoogleFonts.spaceGrotesk(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      titleMedium: GoogleFonts.notoSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      bodyLarge: GoogleFonts.notoSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
      bodyMedium: GoogleFonts.notoSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF9CA3AF),
      ),
      bodySmall: GoogleFonts.notoSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textSecondary,
      ),
    ),

    // AppBar Theme
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: surfaceDark,
      foregroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.spaceGrotesk(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: surfaceBorder),
      ),
      color: surfaceDark,
      margin: EdgeInsets.zero,
    ),

    // Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2A2A2A),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: GoogleFonts.notoSans(
        fontSize: 14,
        color: const Color(0xFF6B7280),
      ),
    ),

    // Divider
    dividerTheme: const DividerThemeData(
      color: Color(0xFF2A3A2A),
      thickness: 1,
      space: 1,
    ),
  );
}