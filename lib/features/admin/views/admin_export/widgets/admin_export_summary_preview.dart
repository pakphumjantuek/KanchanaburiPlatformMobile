import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/admin/theme/admin_colors.dart';
import 'package:projecte/features/admin/controllers/admin_export_controller.dart';

class AdminExportSummaryPreview extends StatelessWidget {
  const AdminExportSummaryPreview({super.key, required this.controller});

  final AdminExportController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final typeInfo = controller.selectedExportTypeInfo;
      final format = controller.selectedFormat.value.toUpperCase();
      final isPdf = controller.selectedFormat.value == 'pdf';
      final rangeText = controller.thaiDateRangeLabel;
      final days = controller.dateRangeDays;
      final color = typeInfo['color'] as Color;

      return Container(
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AdminColors.infoBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFBFDBFE), width: 1.2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.verified_outlined,
                  size: 18,
                  color: AdminColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'สรุปรายงานที่จะส่งออก',
                  style: GoogleFonts.krub(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AdminColors.primaryDark,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: isPdf
                        ? const Color(0xFFE11D48)
                        : const Color(0xFF059669),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    format,
                    style: GoogleFonts.krub(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(typeInfo['icon'] as IconData, size: 16, color: color),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    typeInfo['title'] as String,
                    style: GoogleFonts.krub(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AdminColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.date_range_outlined,
                  size: 16,
                  color: AdminColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '$rangeText ($days วัน)',
                    style: GoogleFonts.krub(
                      fontSize: 12,
                      color: AdminColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
