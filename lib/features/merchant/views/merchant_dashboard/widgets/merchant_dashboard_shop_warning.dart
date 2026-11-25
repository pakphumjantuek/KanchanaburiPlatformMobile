import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/app/routes/app_routes.dart';

class MerchantDashboardShopWarning extends StatelessWidget {
  const MerchantDashboardShopWarning({super.key, this.status});

  final String? status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFDE68A)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xFFD97706),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'แจ้งเตือนสถานะร้านค้า',
                      style: GoogleFonts.krub(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF92400E),
                      ),
                    ),
                    Text(
                      _getStatusDescription(status),
                      style: GoogleFonts.krub(
                        fontSize: 12,
                        color: const Color(0xFFB45309),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => Get.toNamed(AppRoutes.registerShop),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD97706),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              icon: const Icon(Icons.edit_document, size: 18),
              label: Text(
                'ลงทะเบียน / แก้ไขข้อมูลร้านค้า',
                style: GoogleFonts.krub(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusDescription(String? status) {
    if (status == 'PendingApproval') {
      return 'คำขอร้านค้าของคุณกำลังอยู่ระหว่างการตรวจสอบโดยผู้ดูแลระบบ';
    }
    if (status == 'Rejected') {
      return 'ร้านค้าของคุณยังไม่ได้รับการอนุมัติ กรุณาปรับปรุงข้อมูลตามคำแนะนำ';
    }
    if (status == 'Suspended') return 'ร้านค้าของคุณถูกระงับการใช้งานชั่วคราว';
    return 'ยังไม่มีข้อมูลร้านค้าในระบบ กรุณาลงทะเบียนร้านค้า';
  }
}
