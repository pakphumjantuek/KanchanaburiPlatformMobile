import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/merchant/controllers/product_form_controller.dart';
import 'package:projecte/features/merchant/theme/merchant_colors.dart';

class ProductFormStatusToggle extends StatelessWidget {
  const ProductFormStatusToggle({super.key, required this.controller});

  final ProductFormController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isActive = controller.status.value == 'Active';

      return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? MerchantColors.successBg : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive ? const Color(0xFFA7F3D0) : MerchantColors.border,
            width: isActive ? 1.4 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isActive
                    ? MerchantColors.primary.withValues(alpha: 0.15)
                    : const Color(0xFFE2E8F0),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isActive
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_rounded,
                color: isActive
                    ? MerchantColors.primary
                    : const Color(0xFF64748B),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isActive ? 'เปิดขายสินค้าทันที' : 'ซ่อนสินค้านี้ชั่วคราว',
                    style: GoogleFonts.krub(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: isActive
                          ? MerchantColors.primaryDark
                          : MerchantColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isActive
                        ? 'ลูกค้าในระบบสามารถมองเห็นและสั่งซื้อสินค้านี้ได้'
                        : 'สินค้าจะไม่แสดงในหน้าร้านค้าจนกว่าจะเปิดใช้งาน',
                    style: GoogleFonts.krub(
                      fontSize: 11,
                      color: isActive
                          ? MerchantColors.primary
                          : MerchantColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Switch.adaptive(
              value: isActive,
              activeThumbColor: MerchantColors.primary,
              activeTrackColor: const Color(0xFFA7F3D0),
              onChanged: (value) =>
                  controller.status.value = value ? 'Active' : 'Inactive',
            ),
          ],
        ),
      );
    });
  }
}
