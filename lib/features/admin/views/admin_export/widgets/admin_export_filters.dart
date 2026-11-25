import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/admin/theme/admin_colors.dart';
import 'package:projecte/features/admin/controllers/admin_export_controller.dart';
import 'package:projecte/features/admin/views/admin_export/widgets/admin_export_section_card.dart';
import 'package:projecte/features/admin/views/admin_export/widgets/admin_export_input_decoration.dart';

class AdminExportFilters extends StatelessWidget {
  const AdminExportFilters({super.key, required this.controller});

  final AdminExportController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Obx(() {
          final type = controller.selectedExportType.value;
          if (type != 'orders' && type != 'payouts') {
            return const SizedBox.shrink();
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: AdminExportSectionCard(
              stepNumber: '4',
              title: 'ตัวกรองข้อมูลเพิ่มเติม',
              subtitle: 'จำกัดขอบเขตข้อมูลในรายงานตามต้องการ',
              icon: Icons.filter_alt_rounded,
              children: [
                if (type == 'orders')
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
                                color: AdminColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              initialValue: controller.selectedPaymentStatus.value,
                              isExpanded: true,
                              decoration: AdminExportInputDecoration.build(),
                              style: GoogleFonts.krub(
                                fontSize: 13,
                                color: const Color(0xFF0F172A),
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'All',
                                  child: Text('ทั้งหมด'),
                                ),
                                DropdownMenuItem(
                                  value: 'Paid',
                                  child: Text('ชำระเงินแล้ว'),
                                ),
                                DropdownMenuItem(
                                  value: 'PendingVerification',
                                  child: Text('รอตรวจสลิป'),
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
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'สถานะคำสั่งซื้อ',
                              style: GoogleFonts.krub(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AdminColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              initialValue: controller.selectedOrderStatus.value,
                              isExpanded: true,
                              decoration: AdminExportInputDecoration.build(),
                              style: GoogleFonts.krub(
                                fontSize: 13,
                                color: const Color(0xFF0F172A),
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'All',
                                  child: Text('ทั้งหมด'),
                                ),
                                DropdownMenuItem(
                                  value: 'PendingPayment',
                                  child: Text('รอชำระเงิน'),
                                ),
                                DropdownMenuItem(
                                  value: 'PendingVerification',
                                  child: Text('รอตรวจสลิป'),
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
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                if (type == 'payouts')
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'สถานะการโอนเงินให้ร้านค้า',
                        style: GoogleFonts.krub(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AdminColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        initialValue: controller.selectedPayoutStatus.value,
                        isExpanded: true,
                        decoration: AdminExportInputDecoration.build(),
                        style: GoogleFonts.krub(
                          fontSize: 13,
                          color: const Color(0xFF0F172A),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'All',
                            child: Text('ทั้งหมดทุกสถานะ'),
                          ),
                          DropdownMenuItem(
                            value: 'Pending',
                            child: Text('รอนุมัติโอนเงิน'),
                          ),
                          DropdownMenuItem(
                            value: 'Processing',
                            child: Text('กำลังดำเนินการโอน'),
                          ),
                          DropdownMenuItem(
                            value: 'Completed',
                            child: Text('โอนเงินสำเร็จ'),
                          ),
                          DropdownMenuItem(
                            value: 'Failed',
                            child: Text('โอนเงินไม่สำเร็จ'),
                          ),
                        ],
                        onChanged: (v) {
                          if (v != null) {
                            controller.selectedPayoutStatus.value = v;
                          }
                        },
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
