import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/merchant/controllers/product_form_controller.dart';
import 'package:projecte/features/merchant/theme/merchant_colors.dart';

class ProductFormSubmitButton extends StatelessWidget {
  const ProductFormSubmitButton({super.key, required this.controller});

  final ProductFormController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSaving = controller.isSaving.value;
      final isEditing = controller.editingProduct != null;

      return Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          gradient: MerchantColors.headerGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: MerchantColors.primaryDark.withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: isSaving ? null : controller.submitProduct,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          icon: isSaving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.2,
                  ),
                )
              : const Icon(Icons.check_circle_outline_rounded, size: 22),
          label: Text(
            isSaving
                ? 'กำลังบันทึกข้อมูลสินค้า...'
                : (isEditing ? 'บันทึกการแก้ไขข้อมูล' : 'บันทึกและเพิ่มสินค้าใหม่'),
            style: GoogleFonts.krub(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      );
    });
  }
}
