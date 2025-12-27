import 'package:flutter/material.dart';

/// Color Constants for Carebridge App
class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF14B8A6); // Teal
  static const Color primaryDark = Color(0xFF0D9488);
  static const Color primaryLight = Color(0xFF5EEAD4);

  // Accent Colors
  static const Color accent = Color(0xFF3A506B); // Dark Blue
  static const Color accentLight = Color(0xFF5C7A9D);

  // Background Colors
  static const Color cream = Color(0xFFFFF8E7);
  static const Color lightCream = Color(0xFFFFFBF0);
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF8F4E6);

  // Gradient Colors
  static const Color gold = Color(0xFFFFD580);
  static const Color lightBlue = Color(0xFFA8DADC);
  static const Color mutedGreen = Color(0xFFC6E2B5);

  // Text Colors
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF7F8C8D);
  static const Color textLight = Color(0xFF95A5A6);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Status Colors
  static const Color success = Color(0xFF27AE60);
  static const Color successLight = Color(0xFFC6E2B5);
  static const Color warning = Color(0xFFF39C12);
  static const Color warningLight = Color(0xFFFFE5CC);
  static const Color error = Color(0xFFE74C3C);
  static const Color errorLight = Color(0xFFFFB3BA);
  static const Color info = Color(0xFF3498DB);
  static const Color infoLight = Color(0xFFD6EAF8);

  // Border Colors
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderLight = Color(0xFFF3F4F6);
  static const Color borderDark = Color(0xFFD1D5DB);

  // Shadow Colors
  static const Color shadowLight = Color(0x1A3A506B);
  static const Color shadowMedium = Color(0x263A506B);
  static const Color shadowHeavy = Color(0x403A506B);

  // Gradient Colors for Cards
  static const Color purpleStart = Color(0xFF667EEA);
  static const Color purpleEnd = Color(0xFF764BA2);
  static const Color pinkStart = Color(0xFFFF6B9D);
  static const Color pinkEnd = Color(0xFFC06C84);
  static const Color tealStart = Color(0xFF4ECDC4);
  static const Color tealEnd = Color(0xFF44A08D);

  // Mood Colors
  static const Color moodHappy = Color(0xFF27AE60);
  static const Color moodNeutral = Color(0xFFF39C12);
  static const Color moodSad = Color(0xFFE74C3C);

  // Doctor Dashboard Colors
  static const Color doctorDark = Color(0xFF1F2937);
  static const Color doctorGray = Color(0xFF374151);
  static const Color doctorLightGray = Color(0xFF6B7280);
  static const Color doctorBorder = Color(0xFF374151);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, lightBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [cream, Color(0xFFF8F4E6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient purpleGradient = LinearGradient(
    colors: [purpleStart, purpleEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [gold, cream],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient healthGradient = LinearGradient(
    colors: [cream, lightBlue, mutedGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [success, successLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient errorGradient = LinearGradient(
    colors: [error, errorLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient infoGradient = LinearGradient(
    colors: [info, infoLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Chart Colors
  static const List<Color> chartColors = [
    Color(0xFF4ECDC4),
    Color(0xFFFF6B9D),
    Color(0xFFFFD580),
    Color(0xFFC6E2B5),
    Color(0xFFDDA0DD),
    Color(0xFF667EEA),
  ];

  // Sentiment Colors
  static const Color sentimentPositive = Color(0xFF27AE60);
  static const Color sentimentNeutral = Color(0xFFF39C12);
  static const Color sentimentNegative = Color(0xFFE74C3C);
}
