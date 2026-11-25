import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/services/auth_service.dart';

class EditProfileHeaderCard extends StatelessWidget {
  const EditProfileHeaderCard({super.key, required this.authService});

  final AuthService authService;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = authService.currentUser.value;
      var initials = 'U';
      if (user != null && user.displayName.isNotEmpty) {
        final parts = user.displayName.trim().split(' ');
        if (parts.length >= 2) {
          initials = '${parts[0][0]}${parts[1][0]}'.toUpperCase();
        } else {
          initials = user.displayName.substring(0, 1).toUpperCase();
        }
      }

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF9F2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE8D9C9), width: 1.3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFD96C2C),
                        Color(0xFFBF5720),
                        Color(0xFF171412),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFD96C2C).withValues(alpha: 0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      initials,
                      style: GoogleFonts.krub(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFFD96C2C),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              user?.displayName ?? 'ผู้ใช้งาน',
              style: GoogleFonts.krub(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF332820),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              user?.email ?? '-',
              style: GoogleFonts.krub(
                fontSize: 13,
                color: const Color(0xFF786B62),
              ),
            ),
          ],
        ),
      );
    });
  }
}
