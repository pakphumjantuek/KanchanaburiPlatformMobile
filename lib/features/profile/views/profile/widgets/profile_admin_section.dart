import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../app/routes/app_routes.dart';
import 'profile_navigation_tile.dart';
import 'profile_section_card.dart';

class ProfileAdminSection extends StatelessWidget {
  const ProfileAdminSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileSectionCard(
      title: 'ระบบผู้ดูแลระบบ (Admin Management)',
      icon: Icons.admin_panel_settings_rounded,
      children: [
        ProfileNavigationTile(
          icon: Icons.shield_outlined,
          iconColor: const Color(0xFFC8952F),
          title: 'จัดการแอดมิน / ควบคุมระบบ (Admin Dashboard)',
          subtitle: 'เข้าสู่แดชบอร์ดผู้ดูแลระบบเพื่อจัดการ 13 ระบบย่อย',
          onTap: () => Get.toNamed(AppRoutes.admin),
        ),
      ],
    );
  }
}
