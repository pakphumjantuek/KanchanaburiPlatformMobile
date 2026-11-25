import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../cart/controllers/cart_controller.dart';
import '../../controllers/navigation_controller.dart';
import 'navigation_style.dart';

class CartNavigationItem extends StatelessWidget {
  const CartNavigationItem({
    super.key,
    required this.controller,
    required this.cartController,
  });

  final NavigationController controller;
  final CartController cartController;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = controller.selectedIndex.value == 3;
      final count = cartController.totalItemCount;
      return InkWell(
        onTap: () => controller.changeTab(3),
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Badge(
                isLabelVisible: count > 0,
                label: Text(
                  '$count',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 9.5,
                  ),
                ),
                backgroundColor: NavigationStyle.brandPrimary,
                child: Icon(
                  selected
                      ? Icons.shopping_cart_rounded
                      : Icons.shopping_cart_outlined,
                  color: selected
                      ? NavigationStyle.active
                      : NavigationStyle.inactive,
                  size: 22,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'ตะกร้า',
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: selected ? FontWeight.w900 : FontWeight.w600,
                  color: selected
                      ? NavigationStyle.active
                      : NavigationStyle.inactive,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
    });
  }
}
