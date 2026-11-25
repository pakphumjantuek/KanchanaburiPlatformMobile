import 'package:flutter/material.dart';

import '../../../cart/controllers/cart_controller.dart';
import '../../controllers/navigation_controller.dart';
import 'cart_navigation_item.dart';
import 'create_content_navigation_button.dart';
import 'main_navigation_item.dart';
import 'navigation_style.dart';

class MainBottomNavigationBar extends StatelessWidget {
  const MainBottomNavigationBar({
    super.key,
    required this.isLoggedIn,
    required this.controller,
    required this.cartController,
  });

  final bool isLoggedIn;
  final NavigationController controller;
  final CartController cartController;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: NavigationStyle.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(
            children: [
              Expanded(
                child: MainNavigationItem(
                  index: 0,
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  label: 'หน้าแรก',
                  controller: controller,
                ),
              ),
              Expanded(
                child: MainNavigationItem(
                  index: 2,
                  icon: Icons.article_outlined,
                  activeIcon: Icons.article_rounded,
                  label: 'เนื้อหา',
                  controller: controller,
                ),
              ),
            
              const Expanded(child: CreateContentNavigationButton()),
                Expanded(
                child: MainNavigationItem(
                  index: 1,
                  icon: Icons.storefront_outlined,
                  activeIcon: Icons.storefront_rounded,
                  label: 'ร้านค้า',
                  controller: controller,
                ),
              ),
              if (isLoggedIn)
                Expanded(
                  child: CartNavigationItem(
                    controller: controller,
                    cartController: cartController,
                  ),
                ),
              Expanded(
                child: MainNavigationItem(
                  index: isLoggedIn ? 4 : 3,
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                  label: 'โปรไฟล์',
                  controller: controller,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
