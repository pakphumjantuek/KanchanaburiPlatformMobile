import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileBreadcrumb extends StatelessWidget {
  const ProfileBreadcrumb({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F2),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8D9C9), width: 1.1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                'หน้าแรก',
                style: GoogleFonts.krub(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF786B62),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 16,
                color: Colors.grey,
              ),
              Text(
                'บัญชีของฉัน',
                style: GoogleFonts.krub(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFD96C2C),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFD96C2C).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFD96C2C).withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.shield_outlined,
                  size: 12,
                  color: Color(0xFFD96C2C),
                ),
                const SizedBox(width: 4),
                Text(
                  'ระบบจัดการบัญชี',
                  style: GoogleFonts.krub(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFD96C2C),
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
