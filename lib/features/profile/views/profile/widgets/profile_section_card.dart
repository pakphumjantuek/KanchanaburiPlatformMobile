import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileSectionCard extends StatelessWidget {
  const ProfileSectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8D9C9), width: 1.3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
            child: Row(
              children: [
                Icon(icon, size: 18, color: const Color(0xFFD96C2C)),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.krub(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF332820),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE8D9C9)),
          ...children,
        ],
      ),
    );
  }
}
