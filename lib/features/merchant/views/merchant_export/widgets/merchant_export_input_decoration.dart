import 'package:flutter/material.dart';
import 'package:projecte/features/merchant/theme/merchant_colors.dart';

class MerchantExportInputDecoration {
  const MerchantExportInputDecoration._();

  static InputDecoration build() {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: MerchantColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: MerchantColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: MerchantColors.primary, width: 1.8),
      ),
    );
  }
}
