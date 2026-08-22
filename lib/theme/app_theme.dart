import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens — kept identical to the approved wireframe so the build
/// matches the mockup exactly. Change values here, not in individual screens.
class AppColors {
  static const bg = Color(0xFFFAF6F4);
  static const paper = Color(0xFFFFFFFF);
  static const ink = Color(0xFF201B1C);
  static const inkSoft = Color(0xFF6B6062);

  static const blood = Color(0xFFC41E3A);
  static const bloodDeep = Color(0xFF8E1329);

  static const rose = Color(0xFFF6DEE2);
  static const roseLine = Color(0xFFECC7CD);

  static const trust = Color(0xFF3E5568);
  static const trustSoft = Color(0xFFE7EDF1);

  static const go = Color(0xFF1F9D55);
  static const goDeep = Color(0xFF167A42);

  static const offline = Color(0xFF8E6F1E);
  static const offlineSoft = Color(0xFFFBF1DA);
}

class AppTextStyles {
  static TextStyle display({double size = 24, FontWeight w = FontWeight.w800, Color? color}) =>
      GoogleFonts.barlowCondensed(fontSize: size, fontWeight: w, color: color ?? AppColors.ink, height: 1.05);

  static TextStyle body({double size = 13, FontWeight w = FontWeight.w400, Color? color}) =>
      GoogleFonts.inter(fontSize: size, fontWeight: w, color: color ?? AppColors.inkSoft);

  static TextStyle mono({double size = 11, FontWeight w = FontWeight.w700, Color? color}) =>
      GoogleFonts.jetBrainsMono(fontSize: size, fontWeight: w, color: color ?? AppColors.inkSoft);
}

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.bg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.blood,
          primary: AppColors.blood,
          secondary: AppColors.go,
          surface: AppColors.paper,
        ),
        fontFamily: GoogleFonts.inter().fontFamily,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.bg,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppColors.ink),
          titleTextStyle: AppTextStyles.display(size: 19, w: FontWeight.w700),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.blood,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            textStyle: AppTextStyles.display(size: 17, w: FontWeight.w700, color: Colors.white),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.trustSoft,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      );
}
