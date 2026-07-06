import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nova_ai/providers/theme_provider.dart';

class AppTheme {
  static const Color background = Color(0xFF09090B);
  static const Color surface = Color(0xFF16181D);
  static const Color surfaceElevated = Color(0xFF1F222A);
  static const Color secondary = Color(0xFF00D1FF);
  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);

  static const Color fallbackPrimary = Color(0xFF6D5EF9);
  static Color get primary => fallbackPrimary;

  static ThemeData getTheme(AppAccent accent) {
    final primaryColor = accent.color;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: primaryColor,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: secondary,
        surface: surface,
        error: error,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.inter(fontSize: 57, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -1.0),
        displayMedium: GoogleFonts.inter(fontSize: 45, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -0.5),
        displaySmall: GoogleFonts.inter(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
        headlineLarge: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
        headlineMedium: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w600, color: Colors.white),
        headlineSmall: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
        titleLarge: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
        titleMedium: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
        titleSmall: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
        bodyLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.white70, height: 1.5),
        bodyMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.white70, height: 1.4),
        bodySmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.white60),
        labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
        labelMedium: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
        labelSmall: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white70),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.white.withOpacity(0.06), width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: primaryColor.withOpacity(0.4),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceElevated,
        selectedColor: primaryColor.withOpacity(0.25),
        disabledColor: surface.withOpacity(0.5),
        labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white),
        secondaryLabelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: primaryColor),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surfaceElevated,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: surfaceElevated,
        contentTextStyle: GoogleFonts.inter(color: Colors.white, fontSize: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.05)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.05)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );
  }
}
