import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterShopHeaderBanner extends StatelessWidget {
  const RegisterShopHeaderBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF064E3B), Color(0xFF047857), Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF047857).withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MERCHANT APPLICATION',
            style: GoogleFonts.krub(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF6EE7B7),
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'ใบสมัครเปิดร้านค้าใหม่',
            style: GoogleFonts.krub(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'กรอกข้อมูลให้ครบถ้วนแล้วรอเจ้าหน้าที่/แอดมินอนุมัติเพื่อเริ่มขายสินค้าบนแพลตฟอร์ม',
            style: GoogleFonts.krub(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}
