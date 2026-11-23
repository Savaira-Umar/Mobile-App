import 'package:flutter/material.dart';

/// Central color definitions for the SAVAIRA design system.
/// Extracted and matched directly from the design references.
class AppColors {
  AppColors._();

  // Backgrounds & Surface
  static const Color bgGradientStart = Color(0xFFF4F8FF);
  static const Color bgGradientEnd = Color(0xFFFFFFFF);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF8FAFC);

  // Primary Blue (Pill navigation, buttons, accents)
  static const Color primaryBlue = Color(0xFF3B6FE0);
  static const Color primaryBlueDark = Color(0xFF2F62D8);
  static const Color primaryBlueLight = Color(0xFFEBF1FD);
  static const Color primaryBlueBorder = Color(0xFFC7DCFF);

  // Done / Progress Green
  static const Color doneGreen = Color(0xFF34B26B);
  static const Color doneGreenLight = Color(0xFFDDF5E6);
  static const Color doneGreenDark = Color(0xFF258550);

  // Pending / Due / Cross Red
  static const Color dueRed = Color(0xFFE5484D);
  static const Color dueRedLight = Color(0xFFFBD5DB);
  static const Color dueRedDark = Color(0xFFB52A30);

  // Outlines & Borders
  static const Color circleOutline = Color(0xFFCBD5E1);
  static const Color borderSubtle = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFF1F5F9);

  // Typography Colors
  static const Color textNavy = Color(0xFF1F2A44);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textLight = Color(0xFF94A3B8);
  static const Color textWhite = Color(0xFFFFFFFF);

  // User 2 Theme Color
  static const Color user2Pink = Color(0xFFE86C8D);
  static const Color user2PinkLight = Color(0xFFFCEBF0);
  static const Color user2Heart = Color(0xFFFF4D6D);

  // Pastel Tile Backgrounds for Task & Goal Icons
  static const Color pastelBlue = Color(0xFFE5EFFF);
  static const Color pastelGreen = Color(0xFFE3F7EB);
  static const Color pastelPurple = Color(0xFFF0E8FF);
  static const Color pastelPink = Color(0xFFFFEBF0);
  static const Color pastelOrange = Color(0xFFFFF2E2);
  static const Color pastelYellow = Color(0xFFFFFBE0);
  static const Color pastelTeal = Color(0xFFE0F7F6);
  static const Color pastelCoral = Color(0xFFFFEEE8);

  // Matching Icon Foreground Colors
  static const Color iconBlue = Color(0xFF2563EB);
  static const Color iconGreen = Color(0xFF16A34A);
  static const Color iconPurple = Color(0xFF9333EA);
  static const Color iconPink = Color(0xFFDB2777);
  static const Color iconOrange = Color(0xFFEA580C);
  static const Color iconYellow = Color(0xFFCA8A04);
  static const Color iconTeal = Color(0xFF0D9488);
  static const Color iconCoral = Color(0xFFE11D48);

  // Background Gradient
  static const LinearGradient pageBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [bgGradientStart, bgGradientEnd],
  );

  static const LinearGradient primaryButtonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlue, primaryBlueDark],
  );
}
