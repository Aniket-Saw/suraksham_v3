import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Reusable pastel accent colors for cards, badges, and illustrations.
class AppColors {
  AppColors._();

  // Primary palette
  static const Color indigo = Color(0xFF4A55A2);
  static const Color lavender = Color(0xFF7895CB);
  static const Color deepIndigo = Color(0xFF2B3467);

  // Pastel accents for module cards
  static const Color mint = Color(0xFFB8E6D0);
  static const Color mintDark = Color(0xFF2D6A4F);
  static const Color skyBlue = Color(0xFFBBDEFB);
  static const Color skyBlueDark = Color(0xFF1565C0);
  static const Color coral = Color(0xFFFFB4A2);
  static const Color coralDark = Color(0xFFC62828);
  static const Color amber = Color(0xFFFFE0A2);
  static const Color amberDark = Color(0xFFF57F17);
  static const Color lilac = Color(0xFFD5C6E0);
  static const Color lilacDark = Color(0xFF6A1B9A);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [indigo, lavender],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient headerGradient = LinearGradient(
    colors: [Color(0xFF4A55A2), Color(0xFF7895CB), Color(0xFFA0BFE0)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient nightGradient = LinearGradient(
    colors: [Color(0xFF0D1B2A), Color(0xFF1B2838), Color(0xFF2B3467)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

class AppTheme {
  AppTheme._();

  // ─── Light Theme ──────────────────────────────────────────────────────
  static ThemeData get lightTheme {
    final textTheme = GoogleFonts.plusJakartaSansTextTheme(
      ThemeData.light().textTheme,
    );

    const colorScheme = ColorScheme.light(
      primary: AppColors.indigo,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFDDE1FF),
      onPrimaryContainer: AppColors.deepIndigo,
      secondary: AppColors.lavender,
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFFE8EAF6),
      tertiary: Color(0xFFFF8370),
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFFFFDAD4),
      surface: Colors.white,
      onSurface: Color(0xFF1C1B1F),
      surfaceContainerHighest: Color(0xFFF0EFF4),
      error: Color(0xFFBA1A1A),
      outline: Color(0xFFC4C4C4),
      outlineVariant: Color(0xFFE8E8E8),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFFF8F7FC),
      textTheme: textTheme.copyWith(
        displayLarge: textTheme.displayLarge?.copyWith(
          fontWeight: FontWeight.w800,
          color: AppColors.deepIndigo,
        ),
        displayMedium: textTheme.displayMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.deepIndigo,
        ),
        titleLarge: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.deepIndigo,
        ),
        titleMedium: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.deepIndigo,
        ),
        bodyLarge: textTheme.bodyLarge?.copyWith(
          color: const Color(0xFF49454F),
        ),
        bodyMedium: textTheme.bodyMedium?.copyWith(
          color: const Color(0xFF79747E),
        ),
        labelLarge: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.deepIndigo,
          fontSize: 20,
        ),
        iconTheme: const IconThemeData(color: AppColors.indigo),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.indigo,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.indigo,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          side: const BorderSide(color: AppColors.indigo, width: 1.5),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF0EFF4),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.indigo, width: 2),
        ),
        hintStyle: GoogleFonts.plusJakartaSans(
          color: const Color(0xFFAAAAAA),
          fontSize: 14,
        ),
        labelStyle: GoogleFonts.plusJakartaSans(
          color: const Color(0xFF79747E),
          fontSize: 14,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.indigo,
        unselectedItemColor: Color(0xFFAAAAAA),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        showUnselectedLabels: true,
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE8E8E8),
        thickness: 1,
      ),
    );
  }

  // ─── Dark Theme ───────────────────────────────────────────────────────
  static ThemeData get darkTheme {
    final textTheme = GoogleFonts.plusJakartaSansTextTheme(
      ThemeData.dark().textTheme,
    );

    const colorScheme = ColorScheme.dark(
      primary: Color(0xFF8B9FEF),
      onPrimary: AppColors.deepIndigo,
      primaryContainer: AppColors.indigo,
      onPrimaryContainer: Color(0xFFDDE1FF),
      secondary: AppColors.lavender,
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFF3A4A6B),
      tertiary: Color(0xFFFFB4A2),
      onTertiary: Color(0xFF5C1900),
      surface: Color(0xFF1B2838),
      onSurface: Color(0xFFE6E1E5),
      surfaceContainerHighest: Color(0xFF252F3F),
      error: Color(0xFFFFB4AB),
      outline: Color(0xFF4A5568),
      outlineVariant: Color(0xFF2D3748),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFF0D1B2A),
      textTheme: textTheme.copyWith(
        displayLarge: textTheme.displayLarge?.copyWith(
          fontWeight: FontWeight.w800,
          color: const Color(0xFFE6E1E5),
        ),
        displayMedium: textTheme.displayMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: const Color(0xFFE6E1E5),
        ),
        titleLarge: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: const Color(0xFFE6E1E5),
        ),
        titleMedium: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: const Color(0xFFCAC4D0),
        ),
        bodyLarge: textTheme.bodyLarge?.copyWith(
          color: const Color(0xFFCAC4D0),
        ),
        bodyMedium: textTheme.bodyMedium?.copyWith(
          color: const Color(0xFF938F99),
        ),
        labelLarge: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: const Color(0xFFE6E1E5),
          fontSize: 20,
        ),
        iconTheme: const IconThemeData(color: Color(0xFF8B9FEF)),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: const Color(0xFF1B2838),
        surfaceTintColor: Colors.transparent,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8B9FEF),
          foregroundColor: AppColors.deepIndigo,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF8B9FEF),
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          side: const BorderSide(color: Color(0xFF8B9FEF), width: 1.5),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF252F3F),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF8B9FEF), width: 2),
        ),
        hintStyle: GoogleFonts.plusJakartaSans(
          color: const Color(0xFF6B7280),
          fontSize: 14,
        ),
        labelStyle: GoogleFonts.plusJakartaSans(
          color: const Color(0xFF938F99),
          fontSize: 14,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1B2838),
        selectedItemColor: Color(0xFF8B9FEF),
        unselectedItemColor: Color(0xFF6B7280),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        showUnselectedLabels: true,
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF2D3748),
        thickness: 1,
      ),
    );
  }
}
