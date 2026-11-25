import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/merchant/theme/merchant_colors.dart';
import 'package:projecte/features/merchant/controllers/merchant_export_controller.dart';

class MerchantExportSubmitButton extends StatelessWidget {
  const MerchantExportSubmitButton({super.key, required this.controller});

  final MerchantExportController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isExporting = controller.isExporting.value;
      final format = controller.selectedFormat.value.toUpperCase();

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
          onPressed: isExporting ? null : controller.exportReport,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          icon: isExporting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.2,
                  ),
                )
              : const Icon(Icons.file_download_rounded, size: 22),
          label: Text(
            isExporting
                ? 'กำลังประมวลผลและสร้างรายงาน...'
                : 'ส่งออกและดาวน์โหลดรายงาน ($format)',
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
