import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/routes/app_routes.dart';

class MyContentsHeroHeader extends StatelessWidget {
  const MyContentsHeroHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F2),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE8D9C9), width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFD96C2C).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.article_outlined,
                  color: Color(0xFFD96C2C),
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'เรื่องราวและคอนเทนต์ของคุณ',
                      style: GoogleFonts.krub(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: const Color(0xFF332820),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'เรื่องราว บทความท่องเที่ยว และกิจกรรมชุมชนที่คุณได้เขียนและแบ่งปันบนแพลตฟอร์ม',
                      style: GoogleFonts.krub(
                        fontSize: 13,
                        color: const Color(0xFF786B62),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => Get.toNamed(AppRoutes.createContent),
              icon: const Icon(Icons.add_circle_outline_rounded, size: 20),
              label: Text(
                'สร้างคอนเทนต์ใหม่',
                style: GoogleFonts.krub(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD96C2C),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
