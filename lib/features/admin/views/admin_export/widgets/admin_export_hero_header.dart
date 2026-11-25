import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/admin/theme/admin_colors.dart';

class AdminExportHeroHeader extends StatelessWidget {
  const AdminExportHeroHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: const BoxDecoration(
        gradient: AdminColors.headerGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
            child: const Icon(
              Icons.summarize_rounded,
              color: Color(0xFFBAE6FD),
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ศูนย์ส่งออกรายงานระบบแอดมิน',
                  style: GoogleFonts.krub(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'เลือกประเภทรายงานและช่วงเวลาที่ต้องการ แล้วดาวน์โหลดเป็น PDF หรือ CSV ได้ทันที',
                  style: GoogleFonts.krub(
                    fontSize: 12,
                    color: const Color(0xFFBAE6FD).withValues(alpha: 0.9),
                    height: 1.3,
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
