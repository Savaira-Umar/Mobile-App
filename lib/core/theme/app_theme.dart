import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// Complete theme configuration for SAVAIRA.
/// Provides radii, shadows, and ThemeData.
class AppTheme {
  AppTheme._();

  // Radii
  static const double radiusCard = 22.0;
  static const double radiusPill = 999.0;
  static const double radiusTile = 16.0;
  static const double radiusInput = 18.0;

  static final BorderRadius cardBorderRadius = BorderRadius.circular(radiusCard);
  static final BorderRadius pillBorderRadius = BorderRadius.circular(radiusPill);
  static final BorderRadius tileBorderRadius = BorderRadius.circular(radiusTile);
  static final BorderRadius inputBorderRadius = BorderRadius.circular(radiusInput);

  // Shadows
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x0A1F2A44),
      blurRadius: 18,
      offset: Offset(0, 6),
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: Color(0x333B6FE0),
      blurRadius: 14,
      offset: Offset(0, 5),
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> subtleShadow = [
    BoxShadow(
      color: Color(0x081F2A44),
      blurRadius: 8,
      offset: Offset(0, 2),
      spreadRadius: 0,
    ),
  ];

  /// Core light ThemeData matching the design system
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primaryBlue,
      scaffoldBackgroundColor: AppColors.bgGradientStart,
      fontFamily: AppTypography.fontUi,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryBlue,
        onPrimary: AppColors.textWhite,
        secondary: AppColors.doneGreen,
        onSecondary: AppColors.textWhite,
        error: AppColors.dueRed,
        onError: AppColors.textWhite,
        surface: AppColors.cardWhite,
        onSurface: AppColors.textNavy,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: IconThemeData(color: AppColors.textNavy),
        titleTextStyle: AppTypography.heading2,
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: cardBorderRadius),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: AppColors.textWhite,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: pillBorderRadius),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
          textStyle: AppTypography.buttonPrimary,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryBlue,
          side: const BorderSide(color: AppColors.primaryBlue, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: pillBorderRadius),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
          textStyle: AppTypography.buttonOutline,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardWhite,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        hintStyle: AppTypography.bodyMuted,
        border: OutlineInputBorder(
          borderRadius: inputBorderRadius,
          borderSide: const BorderSide(color: AppColors.borderSubtle, width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: inputBorderRadius,
          borderSide: const BorderSide(color: AppColors.borderSubtle, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: inputBorderRadius,
          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: inputBorderRadius,
          borderSide: const BorderSide(color: AppColors.dueRed, width: 1.2),
        ),
      ),
    );
  }
}
