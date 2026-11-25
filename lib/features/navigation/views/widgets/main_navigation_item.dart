import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/navigation_controller.dart';
import 'navigation_style.dart';

class MainNavigationItem extends StatelessWidget {
  const MainNavigationItem({
    super.key,
    required this.index,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.controller,
  });

  final int index;
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final NavigationController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = controller.selectedIndex.value == index;
      return InkWell(
        onTap: () => controller.changeTab(index),
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? NavigationStyle.brandPrimary.withValues(alpha: 0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  selected ? activeIcon : icon,
                  color: selected
                      ? NavigationStyle.active
                      : NavigationStyle.inactive,
                  size: 22,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
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
