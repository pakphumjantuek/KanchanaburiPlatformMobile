import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/merchant/controllers/content_form_controller.dart';
import 'package:projecte/features/merchant/theme/merchant_colors.dart';

class ContentFormSubmitButton extends GetView<ContentFormController> {
  const ContentFormSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSaving = controller.isSaving.value;
      final isEditing = controller.isEditing.value;

      return Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          gradient: isSaving
              ? const LinearGradient(
                  colors: [Color(0xFF94A3B8), Color(0xFF64748B)],
                )
              : MerchantColors.headerGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSaving
              ? null
              : [
                  BoxShadow(
                    color: MerchantColors.primary.withValues(alpha: 0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isSaving ? null : controller.saveContent,
            borderRadius: BorderRadius.circular(16),
            child: Center(
              child: isSaving
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.2,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'กำลังบันทึกข้อมูล...',
                          style: GoogleFonts.krub(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isEditing
                              ? Icons.check_circle_rounded
                              : Icons.send_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          isEditing ? 'บันทึกการแก้ไขบทความ' : 'เผยแพร่เรื่องราวร้านค้า',
                          style: GoogleFonts.krub(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      );
    });
  }
}

