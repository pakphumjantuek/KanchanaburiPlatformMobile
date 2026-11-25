import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterShopInputDecoration {
  const RegisterShopInputDecoration._();

  static InputDecoration build(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.krub(
        color: const Color(0xFF475569),
        fontSize: 14,
      ),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF059669), width: 1.8),
      ),
    );
  }
}
