import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../controllers/checkout_controller.dart';

class CheckoutBottomBar extends GetView<CheckoutController> {
  const CheckoutBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
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
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ยอดชำระสุทธิ',
                    style: GoogleFonts.krub(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  Obx(
                    () => Text(
                      '฿${controller.totalAmount.toStringAsFixed(2)}',
                      style: GoogleFonts.krub(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFD96C2C),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Obx(
                () => AppButton(
                  text: 'สั่งซื้อสินค้า',
                  isLoading: controller.isLoading.value,
                  onPressed: controller.submitCheckout,
                  color: const Color(0xFFD96C2C),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
