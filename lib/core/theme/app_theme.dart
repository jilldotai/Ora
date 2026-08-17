// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  // 1. Core High-Contrast Palette
  static const Color backgroundCharcoal = Color(0xFF0D0D11); // Deep, dark canvas
  static const Color surfaceBlack = Color(0xFF000000);

  // 2. Holographic & Cyber-Neon Accents
  static const Color acidGreen = Color(0xFFB9FF28);
  static const Color cyberCyan = Color(0xFF00FFFF);
  static const Color electricMagenta = Color(0xFFFF007F);
  static const Color neonPurple = Color(0xFF8A2BE2);

  // 2.5 Typography Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B5);
  static const Color cyberNeonCyan = Color(0xFF00FFFF); // Alias for cyberCyan

  // 3. Purposeful Iridescent Gradients
  // This mimics light dispersion (chiral/holographic effect)
  static const LinearGradient holographicGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      acidGreen,
      cyberCyan,
      electricMagenta,
      neonPurple,
    ],
    stops: [0.0, 0.3, 0.7, 1.0], // Controls the smoothness of the blend
  );

  // 4. Glowing Shadows
  static List<BoxShadow> get neonGlow => [
    BoxShadow(
      color: cyberCyan.withValues(alpha: 0.4),
      blurRadius: 12,
      spreadRadius: 2,
      offset: const Offset(-2, -2),
    ),
    BoxShadow(
      color: electricMagenta.withValues(alpha: 0.4),
      blurRadius: 12,
      spreadRadius: 2,
      offset: const Offset(2, 2),
    ),
  ];

  // 5. Global App Theme Data
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundCharcoal,
      fontFamily: 'Roboto', // We can update this to a Google Font later
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}