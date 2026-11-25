import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/routes/app_routes.dart';

class BrowsingHistoryEmptyState extends StatelessWidget {
  const BrowsingHistoryEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: const Color(0xFFD96C2C).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.history_rounded,
                size: 48,
                color: Color(0xFFD96C2C),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'ยังไม่มีประวัติการเข้าชม',
              style: GoogleFonts.krub(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF332820),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'เมื่อคุณเข้าชมเรื่องราวหรือบทความต่างๆ รายการที่คุณดูจะถูกบันทึกไว้ที่นี่',
              textAlign: TextAlign.center,
              style: GoogleFonts.krub(
                fontSize: 13.5,
                color: const Color(0xFF786B62),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Get.toNamed(AppRoutes.contents),
              icon: const Icon(Icons.explore_outlined, size: 18),
              label: Text(
                'สำรวจเรื่องน่าสนใจ',
                style: GoogleFonts.krub(
                  fontSize: 14.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD96C2C),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
