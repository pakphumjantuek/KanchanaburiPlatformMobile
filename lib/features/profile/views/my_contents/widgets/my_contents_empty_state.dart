import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/routes/app_routes.dart';

class MyContentsEmptyState extends StatelessWidget {
  const MyContentsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F2),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE8D9C9), width: 1.5),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFE8D9C9).withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.article_outlined,
              size: 48,
              color: Color(0xFF786B62),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'ไม่พบรายการคอนเทนต์',
            style: GoogleFonts.krub(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: const Color(0xFF332820),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'คุณยังไม่มีบทความหรือกิจกรรมในหมวดหมู่นี้ เริ่มต้นสร้างคอนเทนต์เพื่อแบ่งปันเรื่องราวเมืองกาญจน์กันเลย!',
            textAlign: TextAlign.center,
            style: GoogleFonts.krub(
              fontSize: 13,
              color: const Color(0xFF786B62),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => Get.toNamed(AppRoutes.createContent),
            icon: const Icon(Icons.add, size: 18),
            label: Text(
              'สร้างคอนเทนต์แรกของคุณ',
              style: GoogleFonts.krub(fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD96C2C),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
