import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterShopRejectedBanner extends StatelessWidget {
  const RegisterShopRejectedBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFECDD3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFE11D48)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'ใบสมัครยังไม่ได้รับอนุมัติ โปรดตรวจสอบและแก้ไขข้อมูลให้ถูกต้อง แล้วส่งใหม่เพื่อพิจารณาอีกครั้ง',
              style: GoogleFonts.krub(
                fontSize: 13,
                color: const Color(0xFFBE123C),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
