import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFF2563EB); // Deep Trading Blue
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color accent = Color(0xFF6366F1);

  // Market Ticks
  static const Color greenUp = Color(0xFF10B981); // Bullish Green
  static const Color greenFlash = Color(0xFFD1FAE5);
  static const Color redDown = Color(0xFFEF4444); // Bearish Red
  static const Color redFlash = Color(0xFFFEE2E2);

  // Neutral Light Mode
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Colors.white;
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color borderLight = Color(0xFFE2E8F0);

  // Neutral Dark Mode
  static const Color backgroundDark = Color(0xFF0B0F19);
  static const Color surfaceDark = Color(0xFF151C2C);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color borderDark = Color(0xFF1E293B);

  // Common fallbacks
  static const Color background = backgroundLight;
  static const Color border = borderLight;
  static const Color divider = borderLight;
  static const Color textMuted = textSecondaryLight;
  static const Color textSecondary = textSecondaryLight;
}