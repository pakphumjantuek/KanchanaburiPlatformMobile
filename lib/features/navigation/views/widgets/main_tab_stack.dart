import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../cart/views/cart_page.dart';
import '../../../contents/views/contents_page.dart';
import '../../../home/views/home_page.dart';
import '../../../profile/views/profile/profile_page.dart';
import '../../../shops/views/shop_list/shops_page.dart';
import '../../controllers/navigation_controller.dart';

class MainTabStack extends StatelessWidget {
  const MainTabStack({
    super.key,
    required this.isLoggedIn,
    required this.controller,
  });

  final bool isLoggedIn;
  final NavigationController controller;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomePage(),
      const ShopsPage(),
      const ContentsPage(),
      if (isLoggedIn) const CartPage(),
      const ProfilePage(),
    ];

    return Obx(() {
      var selectedIndex = controller.selectedIndex.value;
      if (selectedIndex >= pages.length) {
        selectedIndex = pages.length - 1;
      }
      return IndexedStack(index: selectedIndex, children: pages);
    });
  }
}
