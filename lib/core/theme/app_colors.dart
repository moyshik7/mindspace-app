import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Palette
  static const Color primaryLightest = Color(0xFFc5ebfe);
  static const Color primaryLight = Color(0xFF9bd9fe);
  static const Color primaryMidLight = Color(0xFF6dc6fe);
  static const Color primaryMid = Color(0xFF48b7ff);
  static const Color primary = Color(0xFF21a9ff);
  static const Color primaryDark = Color(0xFF1d9bff);
  static const Color primaryDeeper = Color(0xFF1689fe);
  static const Color primaryDarkest = Color(0xFF1177ff);
  static const Color accent = Color(0xFF0050b8);

  // Background & Surface
  static const Color background = Color(0xFF0a0a0f);
  static const Color surface = Color(0xFF111118);
  static const Color surfaceElevated = Color(0xFF1a1a24);
  static const Color surfaceBorder = Color(0xFF1e1e2e);

  // Text
  static const Color textPrimary = Color(0xFFf0f4ff);
  static const Color textSecondary = Color(0xFF8892aa);
  static const Color textMuted = Color(0xFF4a5568);

  // Semantic
  static const Color error = Color(0xFFff4757);
  static const Color success = Color(0xFF2ed573);
  static const Color warning = Color(0xFFffa502);

  // Flair colors
  static const Color flairAnxiety = Color(0xFF7c5cbf);
  static const Color flairGratitude = Color(0xFF2ecc71);
  static const Color flairVenting = Color(0xFFe74c3c);
  static const Color flairAdvice = Color(0xFF3498db);
  static const Color flairGrowth = Color(0xFFf39c12);
  static const Color flairOther = Color(0xFF95a5a6);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryDeeper, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient primaryGradientHorizontal = LinearGradient(
    colors: [primaryDeeper, accent],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient cardGlowGradient = LinearGradient(
    colors: [
      Color(0x261689fe),
      Color(0x1A0050b8),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient streakGradient = LinearGradient(
    colors: [
      Color(0xFFff6b35),
      Color(0xFFf7931e),
      Color(0xFFffd700),
    ],
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
  );

  static List<BoxShadow> get primaryGlow => [
        BoxShadow(
          color: primary.withValues(alpha: 0.15),
          blurRadius: 20,
          spreadRadius: 0,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get subtleGlow => [
        BoxShadow(
          color: primary.withValues(alpha: 0.08),
          blurRadius: 16,
          spreadRadius: 0,
          offset: const Offset(0, 2),
        ),
      ];
}
