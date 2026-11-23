import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Typography tokens for SAVAIRA.
/// Bundled fonts:
/// - Nunito: friendly rounded sans for the entire UI
/// - GreatVibes: handwritten script font exclusively for the Savaira logo
/// - NotoNaskhArabic: classical Naskh font for Arabic Quranic duas
class AppTypography {
  AppTypography._();

  static const String fontUi = 'Nunito';
  static const String fontScript = 'GreatVibes';
  static const String fontArabic = 'NotoNaskhArabic';

  // Logo Script Font
  static const TextStyle logoScript = TextStyle(
    fontFamily: fontScript,
    fontSize: 34,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryBlue,
    letterSpacing: 0.5,
  );

  // Large Headings
  static const TextStyle heading1 = TextStyle(
    fontFamily: fontUi,
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: AppColors.textNavy,
    letterSpacing: -0.5,
  );

  static const TextStyle heading2 = TextStyle(
    fontFamily: fontUi,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textNavy,
    letterSpacing: -0.3,
  );

  static const TextStyle heading3 = TextStyle(
    fontFamily: fontUi,
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: AppColors.textNavy,
  );

  // Body & Descriptions
  static const TextStyle body = TextStyle(
    fontFamily: fontUi,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textNavy,
  );

  static const TextStyle bodyMuted = TextStyle(
    fontFamily: fontUi,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontUi,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textLight,
  );

  // Button Labels
  static const TextStyle buttonPrimary = TextStyle(
    fontFamily: fontUi,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.textWhite,
    letterSpacing: 0.2,
  );

  static const TextStyle buttonOutline = TextStyle(
    fontFamily: fontUi,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryBlue,
  );

  // Arabic Dua Styling
  static const TextStyle arabicDua = TextStyle(
    fontFamily: fontArabic,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryBlue,
    height: 1.8,
  );
}
