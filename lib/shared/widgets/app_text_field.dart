import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final FocusNode? focusNode;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final double borderRadius;

  const AppTextField({
    super.key,
    this.labelText,
    this.hintText,
    this.controller,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.textInputAction,
    this.onFieldSubmitted,
    this.focusNode,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.borderRadius = 14.0,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveFill = fillColor ?? const Color(0xFFF7F0E6).withValues(alpha: 0.5);
    final effectiveBorder = borderColor ?? const Color(0xFFEADCCF);
    final effectiveFocusBorder = focusedBorderColor ?? const Color(0xFFD96C2C);

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
      validator: validator,
      style: GoogleFonts.krub(
        fontSize: 15,
        color: const Color(0xFF2B1F17),
      ),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        hintStyle: GoogleFonts.krub(color: Colors.grey[500], fontSize: 14),
        labelStyle: GoogleFonts.krub(color: const Color(0xFF2B1F17)),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: effectiveFill,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: effectiveBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: effectiveBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: effectiveFocusBorder, width: 1.8),
        ),
      ),
    );
  }
}

