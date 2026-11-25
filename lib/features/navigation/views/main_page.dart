import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/auth_service.dart';
import '../../cart/controllers/cart_controller.dart';
import '../controllers/navigation_controller.dart';
import 'widgets/main_bottom_navigation_bar.dart';
import 'widgets/main_tab_stack.dart';

class MainPage extends GetView<NavigationController> {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationController = Get.isRegistered<NavigationController>()
        ? Get.find<NavigationController>()
        : Get.put(NavigationController(), permanent: true);
    final cartController = Get.find<CartController>();
    final authService = Get.find<AuthService>();

    return Obx(() {
      final isLoggedIn = authService.isLoggedIn.value;
      return Scaffold(
        body: MainTabStack(
          isLoggedIn: isLoggedIn,
          controller: navigationController,
        ),
        bottomNavigationBar: MainBottomNavigationBar(
          isLoggedIn: isLoggedIn,
          controller: navigationController,
          cartController: cartController,
        ),
      );
    });
  }
}
