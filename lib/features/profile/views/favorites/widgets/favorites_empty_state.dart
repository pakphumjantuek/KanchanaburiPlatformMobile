import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/routes/app_routes.dart';

class FavoritesEmptyState extends StatelessWidget {
  const FavoritesEmptyState({super.key});

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
              color: const Color(0xFFE76F51).withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite_border_rounded,
              size: 48,
              color: Color(0xFFE76F51),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'ยังไม่มีรายการโปรด',
            style: GoogleFonts.krub(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: const Color(0xFF332820),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'คุณสามารถกดบันทึกบทความหรือสถานที่ท่องเที่ยวที่ถูกใจ เพื่อกลับมาอ่านในภายหลังได้',
            textAlign: TextAlign.center,
            style: GoogleFonts.krub(
              fontSize: 13,
              color: const Color(0xFF786B62),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => Get.toNamed(AppRoutes.contents),
            icon: const Icon(Icons.explore_outlined, size: 18),
            label: Text(
              'สำรวจคอนเทนต์ท่องเที่ยว',
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
