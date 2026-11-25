import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/routes/app_routes.dart';

class CartLoginRequiredView extends StatelessWidget {
  const CartLoginRequiredView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF2B1F17).withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_outline_rounded,
                size: 52,
                color: Color(0xFFD96C2C),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'กรุณาเข้าสู่ระบบก่อนใช้งานตะกร้าสินค้า',
              textAlign: TextAlign.center,
              style: GoogleFonts.krub(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2B1F17),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'เพื่อดูและจัดการรายการสินค้าในตะกร้าส่วนตัวของคุณ\nกรุณาเข้าสู่ระบบหรือสมัครสมาชิกก่อนเริ่มสั่งซื้อ',
              textAlign: TextAlign.center,
              style: GoogleFonts.krub(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: () {
                Get.toNamed(AppRoutes.login);
              },
              icon: const Icon(Icons.login_rounded, size: 20),
              label: Text(
                'เข้าสู่ระบบ / สมัครสมาชิก',
                style: GoogleFonts.krub(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD96C2C),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
