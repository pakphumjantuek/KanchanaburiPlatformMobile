import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/routes/app_routes.dart';

class PaymentSuccessActionButtons extends StatelessWidget {
  const PaymentSuccessActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () {
            Get.offAllNamed(AppRoutes.initial);
            Get.toNamed(AppRoutes.orders);
          },
          icon: const Icon(Icons.receipt_long_rounded, size: 20),
          label: Text(
            'ดูประวัติการสั่งซื้อของฉัน',
            style: GoogleFonts.krub(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD96C2C),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 2,
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () {
            Get.offAllNamed(AppRoutes.initial);
          },
          icon: const Icon(Icons.home_rounded, size: 20),
          label: Text(
            'กลับสู่หน้าหลัก',
            style: GoogleFonts.krub(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF2B1F17),
            side: const BorderSide(color: Color(0xFF2B1F17), width: 1.5),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }
}
