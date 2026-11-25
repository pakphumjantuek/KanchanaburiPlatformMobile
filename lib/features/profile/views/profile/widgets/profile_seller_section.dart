import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../app/routes/app_routes.dart';
import '../../../../merchant/repositories/merchant_repository.dart';
import 'profile_navigation_tile.dart';
import 'profile_section_card.dart';

class ProfileSellerSection extends StatelessWidget {
  const ProfileSellerSection({
    super.key,
    required this.isLoggedIn,
    required this.isAdmin,
    required this.onAuthRequired,
  });

  final bool isLoggedIn;
  final bool isAdmin;
  final ValueChanged<String> onAuthRequired;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      ProfileNavigationTile(
        icon: Icons.store_mall_directory_outlined,
        iconColor: const Color(0xFF1F5F58),
        title: 'ศูนย์ผู้ขาย / ร้านค้าของฉัน',
        subtitle: 'จัดการสินค้า และออเดอร์ของร้านค้า',
        onTap: _openSellerCenter,
      ),
    ];
    if (isAdmin) {
      children.addAll([
        const Divider(height: 1, indent: 52, color: Color(0xFFE8D9C9)),
        ProfileNavigationTile(
          icon: Icons.admin_panel_settings_outlined,
          iconColor: const Color(0xFFC8952F),
          title: 'จัดการแอดมิน / ระบบผู้ดูแลระบบ',
          subtitle: 'จัดการร้านค้า สลิปการโอน หมวดหมู่ และรายงาน',
          onTap: () => Get.toNamed(AppRoutes.admin),
        ),
      ]);
    }

    return ProfileSectionCard(
      title: 'ศูนย์ผู้ขาย & ร้านค้า',
      icon: Icons.storefront_rounded,
      children: children,
    );
  }

  Future<void> _openSellerCenter() async {
    if (!isLoggedIn) {
      onAuthRequired('ศูนย์ผู้ขาย');
      return;
    }
    final shop = await MerchantRepository().fetchMyShop();
    Get.toNamed(shop == null ? AppRoutes.registerShop : AppRoutes.myShop);
  }
}
