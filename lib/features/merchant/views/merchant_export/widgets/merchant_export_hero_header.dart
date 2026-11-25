import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/merchant/theme/merchant_colors.dart';

class MerchantExportHeroHeader extends StatelessWidget {
  const MerchantExportHeroHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 22),
      decoration: const BoxDecoration(
        gradient: MerchantColors.heroGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(26)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.25),
              ),
            ),
            child: const Icon(
              Icons.analytics_rounded,
              color: Color(0xFFFDE68A),
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ศูนย์ส่งออกรายงานร้านค้า',
                  style: GoogleFonts.krub(
                    fontSize: 16.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'เลือกประเภทรายงานและช่วงเวลาที่ต้องการ แล้วดาวน์โหลดเป็น PDF หรือ CSV ได้ทันที',
                  style: GoogleFonts.krub(
                    fontSize: 12,
                    color: const Color(0xFFA7F3D0).withValues(alpha: 0.95),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
