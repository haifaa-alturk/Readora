import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // =========================================================
  // Base Colors
  // =========================================================

  static const Color surfaceWhite = Color(0xFFFFFFFF);

  static const Color textPrimary = Color(0xFF2D2D2D);

  static const Color textSecondary = Color(0xFF757575);

  static const Color borderLight = Color(0xFFE0E0E0);

  static const Color errorRed = Color(0xFFD32F2F);

  // =========================================================
  // Pink Colors
  // =========================================================

  static const Color pinkLight = Color(0xFFFCE4EC);

  static const Color pinkSoft = Color(0xFFF8BBD0);

  static const Color pinkMedium = Color(0xFFF48FB1);

  static const Color pinkDark = Color(0xFFE91E63);

  // أسماء مستخدمة مسبقاً ببعض الشاشات
  static const Color lightPink = pinkLight;

  static const Color darkPink = pinkDark;

  // =========================================================
  // Sky Blue Colors
  // =========================================================

  static const Color skyLight = Color(0xFFE1F5FE);

  static const Color skySoft = Color(0xFFB3E5FC);

  static const Color skyMedium = Color(0xFF81D4FA);

  static const Color skyDark = Color(0xFF29B6F6);

  // =========================================================
  // Purple Colors
  // =========================================================

  static const Color purpleLight = Color(0xFFF3E5F5);

  static const Color purpleSoft = Color(0xFFE1BEE7);

  static const Color purpleMedium = Color(0xFFCE93D8);

  static const Color purpleDark = Color(0xFFAB47BC);

  // =========================================================
  // Material-style Purple Palette
  // =========================================================

  static const Color purple50 = Color(0xFFF3E5F5);
  static const Color purple100 = Color(0xFFE1BEE7);
  static const Color purple200 = Color(0xFFCE93D8);
  static const Color purple300 = Color(0xFFBA68C8);
  static const Color purple500 = Color(0xFF9C27B0);
  static const Color purple700 = Color(0xFF7B1FA2);
  static const Color purple900 = Color(0xFF4A148C);

  // =========================================================
  // Material-style Pink Palette
  // =========================================================

  static const Color pink50 = Color(0xFFFCE4EC);
  static const Color pink100 = Color(0xFFF8BBD0);
  static const Color pink200 = Color(0xFFF48FB1);
  static const Color pink300 = Color(0xFFF06292);
  static const Color pink500 = Color(0xFFE91E63);
  static const Color pink700 = Color(0xFFC2185B);
  static const Color pink900 = Color(0xFF880E4F);

  // =========================================================
  // Material-style Blue Palette
  // =========================================================

  static const Color blue50 = Color(0xFFE3F2FD);
  static const Color blue100 = Color(0xFFBBDEFB);
  static const Color blue200 = Color(0xFF90CAF9);
  static const Color blue300 = Color(0xFF64B5F6);
  static const Color blue500 = Color(0xFF2196F3);
  static const Color blue700 = Color(0xFF1976D2);
  static const Color blue900 = Color(0xFF0D47A1);

  // =========================================================
  // Status Colors
  // =========================================================

  static const Color successGreen = Color(0xFF4CAF50);

  // =========================================================
  // Common Gradients
  // =========================================================

  static const LinearGradient pinkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [pinkLight, pinkSoft, pinkMedium],
  );

  static const LinearGradient skyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [skyLight, skySoft, skyMedium],
  );

  static const LinearGradient purpleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [purpleLight, purpleSoft, purpleMedium],
  );

  // =========================================================
  // Additional Colors
  // =========================================================

  static const Color gold = Color(0xFFFFC107);

  static const Color green = Color(0xFF4CAF50);

  static const Color greenLight = Color(0xFFE8F5E9);

  static const Color orange = Color(0xFFFF9800);

  static const Color orangeLight = Color(0xFFFFF3E0);

  static const Color blue = Color(0xFF2196F3);

  static const Color blueLight = Color(0xFFE3F2FD);

  static const Color purple = purpleDark;

  // =========================================================
  // Book Details Colors
  // =========================================================

  static const Color bookBackground = Color(0xFFFFFBFD);

  static const Color cardBackground = Color(0xFFFFFFFF);

  static const Color primaryButton = pinkDark;

  static const Color secondaryButton = purpleDark;

  static const Color rentButton = skyDark;

  static const Color buyButton = pinkDark;

  static const Color previewButton = purpleDark;

  static const Color commentButton = skyDark;

  // =========================================================
  // App Theme
  // =========================================================

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,

      scaffoldBackgroundColor: bookBackground,

      colorScheme:
          ColorScheme.fromSeed(
            seedColor: pinkDark,
            brightness: Brightness.light,
          ).copyWith(
            primary: pinkDark,
            secondary: purpleDark,
            surface: surfaceWhite,
            error: errorRed,
          ),

      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceWhite,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
      ),

      cardTheme: CardThemeData(
        color: cardBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: pinkDark, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: errorRed),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: pinkDark,
          foregroundColor: Colors.white,
          elevation: 2,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: pinkDark),
      ),

      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: textPrimary),
      ),

      dividerTheme: const DividerThemeData(color: borderLight, thickness: 1),

      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: textPrimary),
        bodyMedium: TextStyle(color: textSecondary),
        bodySmall: TextStyle(color: textSecondary),
      ),
    );
  }
}
