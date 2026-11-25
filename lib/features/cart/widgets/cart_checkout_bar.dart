import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/routes/app_routes.dart';
import '../controllers/cart_controller.dart';

class CartCheckoutBar extends GetView<CartController> {
  const CartCheckoutBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF332820).withValues(alpha: 0.10),
            blurRadius: 18,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Summary column
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => Text(
                      'ราคารวมทั้งหมด (${controller.selectedItemCount} ชิ้น)',
                      style: GoogleFonts.krub(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '฿',
                        style: GoogleFonts.krub(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFD96C2C),
                        ),
                      ),
                      Obx(
                        () => Text(
                          controller.totalPrice.toStringAsFixed(2),
                          style: GoogleFonts.krub(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFFD96C2C),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Checkout CTA Button
            ElevatedButton(
              onPressed: () {
                if (controller.selectedItemCount == 0) {
                  Get.snackbar(
                    'ยังไม่ได้เลือกสินค้า',
                    'กรุณาเลือกสินค้าอย่างน้อย 1 รายการในตะกร้าเพื่อทำรายการสั่งซื้อ',
                    backgroundColor: const Color(0xFFC62828),
                    colorText: Colors.white,
                    snackPosition: SnackPosition.TOP,
                  );
                  return;
                }
                Get.toNamed(AppRoutes.checkout);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD96C2C),
                disabledBackgroundColor: Colors.grey[400],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'สั่งซื้อสินค้า',
                    style: GoogleFonts.krub(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.arrow_forward_rounded, size: 18),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
