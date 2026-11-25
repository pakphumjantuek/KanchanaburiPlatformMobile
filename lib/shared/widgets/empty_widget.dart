import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmptyWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const EmptyWidget({
    super.key,
    this.title = 'ไม่พบข้อมูล',
    this.message = 'ไม่มีรายการข้อมูลที่จะแสดงในขณะนี้',
    this.icon = Icons.inbox_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFD96C2C).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 40,
                color: const Color(0xFFD96C2C),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.krub(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2B1F17),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.krub(
                fontSize: 13.5,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
