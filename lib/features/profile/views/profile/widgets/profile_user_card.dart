import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/routes/app_routes.dart';
import '../../../../../features/auth/models/user_model.dart';

class ProfileUserCard extends StatelessWidget {
  const ProfileUserCard({
    super.key,
    required this.isLoggedIn,
    required this.user,
  });

  final bool isLoggedIn;
  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    var initials = 'G';
    final displayName = user?.displayName ?? '';
    if (isLoggedIn && displayName.isNotEmpty) {
      final parts = displayName.trim().split(' ');
      initials = parts.length >= 2
          ? '${parts[0][0]}${parts[1][0]}'.toUpperCase()
          : displayName.substring(0, 1).toUpperCase();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: isLoggedIn
                        ? const [
                            Color(0xFFD96C2C),
                            Color(0xFFBF5720),
                            Color(0xFF171412),
                          ]
                        : [Colors.grey[400]!, Colors.grey[600]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD96C2C).withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    isLoggedIn ? initials : 'G',
                    style: GoogleFonts.krub(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              if (isLoggedIn)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: isLoggedIn && user != null
                ? _signedInInfo(user!)
                : _signedOutInfo(),
          ),
        ],
      ),
    );
  }

  Widget _signedInInfo(UserModel user) {
    final isAdmin = user.isAdmin;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          user.displayName.isNotEmpty ? user.displayName : 'สมาชิกกาญจนบุรี',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.krub(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF332820),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          user.email,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.krub(fontSize: 12.5, color: Color(0xFF786B62)),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFFD96C2C).withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFD96C2C).withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            isAdmin ? '👑 ผู้ดูแลระบบ' : '⭐ สมาชิกกาญจนบุรี',
            style: GoogleFonts.krub(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFD96C2C),
            ),
          ),
        ),
      ],
    );
  }

  Widget _signedOutInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ยังไม่ได้เข้าสู่ระบบ',
          style: GoogleFonts.krub(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF332820),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'เข้าสู่ระบบเพื่อใช้งานฟีเจอร์เต็มรูปแบบ',
          style: GoogleFonts.krub(fontSize: 12, color: Color(0xFF786B62)),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => Get.toNamed(AppRoutes.login),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFD96C2C),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'เข้าสู่ระบบ / สมัครสมาชิก',
              style: GoogleFonts.krub(
                fontSize: 12.5,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
