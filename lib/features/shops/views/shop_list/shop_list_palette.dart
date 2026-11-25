import 'package:flutter/material.dart';

/// Design tokens and color system for the Shop List feature,
/// matching the app-wide navy + orange palette (see HomeColors).
abstract final class ShopListPalette {
  // Canvas & Backgrounds
  static const canvas = Color(0xFFF7F3EE);
  static const surface = Colors.white;
  static const surfaceMuted = Color(0xFFF1EAE2);

  // Typography & Inks
  static const ink = Color(0xFF0F172A); // Navy ink
  static const inkSecondary = Color(0xFF334155);
  static const muted = Color(0xFF64748B); // Slate
  static const mutedLight = Color(0xFF94A3B8);

  // Brand Accents
  static const primary = Color(0xFFC85A17); // Brand orange
  static const primaryDark = Color(0xFF0F172A); // Navy header
  static const primaryLight = Color(0xFFE8833A); // Light orange
  static const primarySoft = Color(0xFFFFF3EB);

  // Coral & Amber (Deals & Highlights)
  static const orange = Color(0xFFE5484D); // Deal red
  static const orangeDark = Color(0xFFC53035);
  static const orangeSoft = Color(0xFFFFECEC);
  static const gold = Color(0xFFF2B33D);
  static const goldSoft = Color(0xFFFFF7E6);

  // Status & Dividers
  static const line = Color(0xFFEDE6DE);
  static const lineLight = Color(0xFFF4EFE9);
  static const green = Color(0xFF16A34A);
  static const greenSoft = Color(0xFFE8F7EE);
  static const red = Color(0xFFE63946);

  // Shadows
  static const cardShadow = [
    BoxShadow(color: Color(0x0C0F172A), blurRadius: 16, offset: Offset(0, 6)),
    BoxShadow(color: Color(0x050F172A), blurRadius: 4, offset: Offset(0, 2)),
  ];

  static const heroShadow = [
    BoxShadow(color: Color(0x180F172A), blurRadius: 24, offset: Offset(0, 10)),
  ];
}
