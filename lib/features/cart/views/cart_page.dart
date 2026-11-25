import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/auth_service.dart';
import '../controllers/cart_controller.dart';
import '../widgets/cart_checkout_bar.dart';
import '../widgets/cart_confirm_dialog.dart';
import '../widgets/cart_empty_view.dart';
import '../widgets/cart_login_required_view.dart';
import '../widgets/cart_select_all_bar.dart';
import '../widgets/cart_shop_group_card.dart';

class CartPage extends GetView<CartController> {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F0E6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B1F17),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const Icon(
              Icons.shopping_cart_rounded,
              color: Color(0xFFD96C2C),
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              'ตะกร้าสินค้า',
              style: GoogleFonts.krub(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            Obx(() {
              final authService = Get.find<AuthService>();
              if (!authService.isLoggedIn.value) return const SizedBox.shrink();
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFD96C2C),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${controller.totalItemCount}',
                  style: GoogleFonts.krub(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              );
            }),
          ],
        ),
        actions: [
          Obx(() {
            final authService = Get.find<AuthService>();
            if (!authService.isLoggedIn.value || controller.cartItems.isEmpty) {
              return const SizedBox.shrink();
            }
            return TextButton.icon(
              onPressed: () => showConfirmClearCartDialog(context, controller),
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.white70,
                size: 18,
              ),
              label: Text(
                'ล้างตะกร้า',
                style: GoogleFonts.krub(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }),
        ],
      ),
      body: Obx(() {
        final authService = Get.find<AuthService>();
        if (!authService.isLoggedIn.value) {
          return const CartLoginRequiredView();
        }

        if (controller.cartItems.isEmpty) {
          return const CartEmptyView();
        }

        final grouped = controller.groupedByShop;

        return Column(
          children: [
            // 1. Select All Header Bar
            const CartSelectAllBar(),
            const Divider(height: 1, color: Color(0xFFEADCCF)),

            // 2. Cart Items List Grouped by Shop
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: grouped.keys.length,
                itemBuilder: (context, index) {
                  final shopId = grouped.keys.elementAt(index);
                  final items = grouped[shopId]!;

                  return CartShopGroupCard(shopId: shopId, items: items);
                },
              ),
            ),

            // 3. Bottom Sticky Checkout Bar
            const CartCheckoutBar(),
          ],
        );
      }),
    );
  }
}
