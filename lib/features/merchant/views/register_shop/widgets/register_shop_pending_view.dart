import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterShopPendingView extends StatelessWidget {
  const RegisterShopPendingView({super.key, required this.shopName});

  final String shopName;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0xFFFDE68A)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.hourglass_top_rounded,
                  size: 44,
                  color: Color(0xFFD97706),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'ส่งใบสมัครเรียบร้อยแล้ว',
                style: GoogleFonts.krub(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'ร้าน “$shopName” อยู่ในระหว่างการตรวจสอบและอนุมัติจากแอดมิน',
                textAlign: TextAlign.center,
                style: GoogleFonts.krub(
                  fontSize: 14,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'เมื่อได้รับอนุมัติแล้ว คุณจะสามารถเข้าถึงเมนูจัดการร้านค้า สินค้า และคำสั่งซื้อได้ทันที',
                textAlign: TextAlign.center,
                style: GoogleFonts.krub(
                  fontSize: 12,
                  color: const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
