import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoritesHeaderCard extends StatelessWidget {
  const FavoritesHeaderCard({super.key});

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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE76F51).withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite_rounded,
              color: Color(0xFFE76F51),
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'รายการโปรดที่บันทึกไว้',
                  style: GoogleFonts.krub(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: const Color(0xFF332820),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'รวมเรื่องราว สถานที่ท่องเที่ยว และบทความที่คุณชื่นชอบและกดบันทึกเก็บไว้',
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
    );
  }
}
