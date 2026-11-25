import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/services/auth_service.dart';
import 'profile_account_section.dart';
import 'profile_activity_section.dart';
import 'profile_admin_section.dart';
import 'profile_breadcrumb.dart';
import 'profile_help_section.dart';
import 'profile_seller_section.dart';
import 'profile_user_card.dart';

class ProfileContent extends StatelessWidget {
  const ProfileContent({
    super.key,
    required this.authService,
    required this.onAuthRequired,
    required this.onInfo,
    required this.onLogout,
  });

  final AuthService authService;
  final ValueChanged<String> onAuthRequired;
  final ProfileInfoCallback onInfo;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoggedIn = authService.isLoggedIn.value;
      final user = authService.currentUser.value;
      final isAdmin = user?.isAdmin == true;

      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProfileBreadcrumb(),
            const SizedBox(height: 14),
            ProfileUserCard(isLoggedIn: isLoggedIn, user: user),
            const SizedBox(height: 14),
            ProfileAccountSection(
              isLoggedIn: isLoggedIn,
              onAuthRequired: onAuthRequired,
            ),
            const SizedBox(height: 14),
            ProfileActivitySection(
              isLoggedIn: isLoggedIn,
              onAuthRequired: onAuthRequired,
            ),
            const SizedBox(height: 14),
            ProfileSellerSection(
              isLoggedIn: isLoggedIn,
              isAdmin: isAdmin,
              onAuthRequired: onAuthRequired,
            ),
            if (isAdmin) ...[
              const SizedBox(height: 14),
              const ProfileAdminSection(),
            ],
            const SizedBox(height: 14),
            ProfileHelpSection(onInfo: onInfo),
            const SizedBox(height: 22),
            if (isLoggedIn) ...[
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: onLogout,
                  icon: const Icon(Icons.logout_rounded, size: 20),
                  label: Text(
                    'ออกจากระบบ',
                    style: GoogleFonts.krub(
                      fontSize: 15.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFE53935),
                    backgroundColor: Colors.white,
                    side: const BorderSide(
                      color: Color(0xFFE53935),
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
            ],
            Center(
              child: Text(
                'กาญจนบุรี แพลตฟอร์ม v1.0.0',
                style: GoogleFonts.krub(
                  fontSize: 12,
                  color: const Color(0xFF786B62),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    });
  }
}
