import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../app/routes/app_routes.dart';
import 'profile_navigation_tile.dart';
import 'profile_section_card.dart';

class ProfileActivitySection extends StatelessWidget {
  const ProfileActivitySection({
    super.key,
    required this.isLoggedIn,
    required this.onAuthRequired,
  });

  final bool isLoggedIn;
  final ValueChanged<String> onAuthRequired;

  @override
  Widget build(BuildContext context) {
    return ProfileSectionCard(
      title: 'กิจกรรมและการใช้งาน',
      icon: Icons.interests_outlined,
      children: [
        ProfileNavigationTile(
          icon: Icons.article_outlined,
          title: 'คอนเทนต์ของฉัน',
          subtitle: 'เรื่องราวและบทความที่คุณเขียนหรือโพสต์ไว้',
          badgeText: isLoggedIn ? 'คอนเทนต์' : null,
          badgeColor: const Color(0xFFD96C2C),
          onTap: () => _open(AppRoutes.myContents, 'คอนเทนต์ของฉัน'),
        ),
        const Divider(height: 1, indent: 52, color: Color(0xFFE8D9C9)),
        ProfileNavigationTile(
          icon: Icons.favorite_border_rounded,
          title: 'รายการโปรดที่บันทึกไว้',
          subtitle: 'เรื่องราว สถานที่ท่องเที่ยว และบทความที่คุณชื่นชอบ',
          badgeText: isLoggedIn ? 'โปรด' : null,
          badgeColor: const Color(0xFFE76F51),
          onTap: () => _open(AppRoutes.favorites, 'รายการโปรด'),
        ),
        const Divider(height: 1, indent: 52, color: Color(0xFFE8D9C9)),
        ProfileNavigationTile(
          icon: Icons.receipt_long_outlined,
          title: 'ประวัติคำสั่งซื้อ',
          subtitle: 'ตรวจสอบสถานะและประวัติการสั่งซื้อ',
          badgeText: isLoggedIn ? 'ออเดอร์' : null,
          badgeColor: const Color(0xFFD96C2C),
          onTap: () => _open(AppRoutes.orders, 'ประวัติคำสั่งซื้อ'),
        ),
        const Divider(height: 1, indent: 52, color: Color(0xFFE8D9C9)),
        ProfileNavigationTile(
          icon: Icons.history_rounded,
          title: 'ประวัติการเข้าชม',
          subtitle: 'เรื่องราวและบทความที่คุณเคยเปิดอ่าน',
          badgeText: isLoggedIn ? 'ประวัติ' : null,
          badgeColor: const Color(0xFFD96C2C),
          onTap: () => _open(AppRoutes.history, 'ประวัติการเข้าชม'),
        ),
      ],
    );
  }

  void _open(String route, String feature) {
    if (isLoggedIn) {
      Get.toNamed(route);
    } else {
      onAuthRequired(feature);
    }
  }
}
