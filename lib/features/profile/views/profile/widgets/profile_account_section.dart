import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../app/routes/app_routes.dart';
import 'profile_navigation_tile.dart';
import 'profile_section_card.dart';

class ProfileAccountSection extends StatelessWidget {
  const ProfileAccountSection({
    super.key,
    required this.isLoggedIn,
    required this.onAuthRequired,
  });

  final bool isLoggedIn;
  final ValueChanged<String> onAuthRequired;

  @override
  Widget build(BuildContext context) {
    return ProfileSectionCard(
      title: 'บัญชีของฉัน',
      icon: Icons.person_outline_rounded,
      children: [
        ProfileNavigationTile(
          icon: Icons.badge_outlined,
          title: 'ข้อมูลส่วนตัว',
          subtitle: 'จัดการชื่อ อีเมล และรหัสผ่าน',
          onTap: () {
            if (isLoggedIn) {
              Get.toNamed(AppRoutes.editProfile);
            } else {
              onAuthRequired('ข้อมูลส่วนตัว');
            }
          },
        ),
        const Divider(height: 1, indent: 52, color: Color(0xFFE8D9C9)),
        ProfileNavigationTile(
          icon: Icons.location_on_outlined,
          title: 'สมุดที่อยู่จัดส่ง',
          subtitle: 'จัดการที่อยู่สำหรับส่งสินค้า',
          onTap: () {
            if (isLoggedIn) {
              Get.snackbar(
                'ที่อยู่จัดส่ง',
                'จัดการที่อยู่สำหรับจัดส่งสินค้าของคุณ',
                snackPosition: SnackPosition.TOP,
                backgroundColor: const Color(0xFF2B1F17),
                colorText: Colors.white,
              );
            } else {
              onAuthRequired('สมุดที่อยู่จัดส่ง');
            }
          },
        ),
      ],
    );
  }
}
