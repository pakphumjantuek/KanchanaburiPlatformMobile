import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/merchant/theme/merchant_colors.dart';
import 'package:projecte/features/merchant/controllers/merchant_export_controller.dart';

class MerchantExportSummaryPreview extends StatelessWidget {
  const MerchantExportSummaryPreview({super.key, required this.controller});

  final MerchantExportController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final typeInfo = controller.selectedExportTypeInfo;
      final format = controller.selectedFormat.value.toUpperCase();
      final isPdf = controller.selectedFormat.value == 'pdf';
      final rangeText = controller.thaiDateRangeLabel;
      final days = controller.dateRangeDays;
      final color = typeInfo['color'] as Color;
      final isOrders = controller.selectedExportType.value == 'orders';
      final payStatus = controller.selectedPaymentStatus.value;
      final orderStatus = controller.selectedOrderStatus.value;

      return Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: MerchantColors.successBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFA7F3D0), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: MerchantColors.primary.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.verified_outlined,
                  size: 18,
                  color: MerchantColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'สรุปข้อมูลรายงานที่จะดาวน์โหลด',
                  style: GoogleFonts.krub(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: MerchantColors.primaryDark,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 3.5,
                  ),
                  decoration: BoxDecoration(
                    color: isPdf
                        ? const Color(0xFFE11D48)
                        : const Color(0xFF059669),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: (isPdf
                                ? const Color(0xFFE11D48)
                                : const Color(0xFF059669))
                            .withValues(alpha: 0.25),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
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
            const SizedBox(height: 12),
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
                      color: MerchantColors.textPrimary,
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
                  color: MerchantColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '$rangeText ($days วัน)',
                    style: GoogleFonts.krub(
                      fontSize: 12,
                      color: MerchantColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            if (isOrders && (payStatus != 'All' || orderStatus != 'All')) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.filter_alt_outlined,
                    size: 16,
                    color: MerchantColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'ตัวกรอง: ชำระเงิน ($payStatus) • สถานะ ($orderStatus)',
                      style: GoogleFonts.krub(
                        fontSize: 11.5,
                        color: MerchantColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      );
    });
  }
}
