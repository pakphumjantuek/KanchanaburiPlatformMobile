import 'package:flutter/material.dart';

/// Executive Midnight Navy Design System for Antigravity Admin
class AdminColors {
  AdminColors._();

  // Core Executive Navy Palette
  static const Color primaryDark = Color(
    0xFF0A192F,
  ); // Deep Midnight Navy (0xFF0A192F / 0xFF0F172A)
  static const Color primary = Color(0xFF1E3A8A); // Deep Royal Navy Blue
  static const Color primaryLight = Color(0xFF2563EB); // Vibrant Executive Blue
  static const Color secondary = Color(0xFF0284C7); // Ocean Blue
  static const Color accent = Color(0xFF3B82F6); // Executive Blue
  static const Color gold = Color(0xFFF59E0B); // Executive Amber Gold

  // Gradients
  static const LinearGradient headerGradient = LinearGradient(
    colors: [primaryDark, primary],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [primaryDark, Color(0xFF1E40AF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardAccentGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Surface & Neutrals
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color border = Color(0xFFE2E8F0);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);

  // Status Badges & Indicators
  static const Color success = Color(0xFF059669);
  static const Color successBg = Color(0xFFECFDF5);
  static const Color warning = Color(0xFFD97706);
  static const Color warningBg = Color(0xFFFFFBEB);
  static const Color error = Color(0xFFDC2626);
  static const Color errorBg = Color(0xFFFEF2F2);
  static const Color info = Color(0xFF2563EB);
  static const Color infoBg = Color(0xFFEFF6FF);
}
