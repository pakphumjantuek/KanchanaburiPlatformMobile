import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/merchant/theme/merchant_colors.dart';
import 'package:projecte/features/merchant/controllers/merchant_export_controller.dart';
import 'package:projecte/features/merchant/views/merchant_export/widgets/merchant_export_section_card.dart';
import 'package:projecte/features/merchant/views/merchant_export/widgets/merchant_export_input_decoration.dart';

class MerchantExportOrderFilters extends StatelessWidget {
  const MerchantExportOrderFilters({super.key, required this.controller});

  final MerchantExportController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Obx(() {
          if (controller.selectedExportType.value != 'orders') {
            return const SizedBox.shrink();
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: MerchantExportSectionCard(
              stepNumber: '4',
              title: 'ตัวกรองคำสั่งซื้อเพิ่มเติม',
              subtitle: 'คัดกรองเฉพาะสถานะการชำระเงินหรือสถานะออเดอร์ที่ต้องการ',
              icon: Icons.filter_alt_rounded,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'สถานะการชำระเงิน',
                            style: GoogleFonts.krub(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: MerchantColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Obx(() {
                            return DropdownButtonFormField<String>(
                              initialValue: controller.selectedPaymentStatus.value,
                              isExpanded: true,
                              decoration: MerchantExportInputDecoration.build(),
                              style: GoogleFonts.krub(
                                fontSize: 13,
                                color: MerchantColors.textPrimary,
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'All',
                                  child: Text('ทั้งหมด'),
                                ),
                                DropdownMenuItem(
                                  value: 'Paid',
                                  child: Text('ชำระแล้ว'),
                                ),
                                DropdownMenuItem(
                                  value: 'PendingVerification',
                                  child: Text('รอระบบยืนยันยอด'),
                                ),
                                DropdownMenuItem(
                                  value: 'Unpaid',
                                  child: Text('ยังไม่ชำระ'),
                                ),
                              ],
                              onChanged: (v) {
                                if (v != null) {
                                  controller.selectedPaymentStatus.value = v;
                                }
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'สถานะออเดอร์',
                            style: GoogleFonts.krub(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: MerchantColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Obx(() {
                            return DropdownButtonFormField<String>(
                              initialValue: controller.selectedOrderStatus.value,
                              isExpanded: true,
                              decoration: MerchantExportInputDecoration.build(),
                              style: GoogleFonts.krub(
                                fontSize: 13,
                                color: MerchantColors.textPrimary,
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'All',
                                  child: Text('ทั้งหมด'),
                                ),
                                DropdownMenuItem(
                                  value: 'Shipped',
                                  child: Text('จัดส่งแล้ว'),
                                ),
                                DropdownMenuItem(
                                  value: 'Completed',
                                  child: Text('สำเร็จ'),
                                ),
                                DropdownMenuItem(
                                  value: 'Cancelled',
                                  child: Text('ยกเลิก'),
                                ),
                              ],
                              onChanged: (v) {
                                if (v != null) {
                                  controller.selectedOrderStatus.value = v;
                                }
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
