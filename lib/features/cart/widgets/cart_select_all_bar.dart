import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/cart_controller.dart';

class CartSelectAllBar extends GetView<CartController> {
  const CartSelectAllBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.white,
      child: Row(
        children: [
          Obx(
            () => Checkbox(
              value: controller.isAllSelected,
              activeColor: const Color(0xFFD96C2C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              onChanged: (val) {
                controller.toggleSelectAll(val ?? false);
              },
            ),
          ),
          Text(
            'เลือกสินค้าทั้งหมด',
            style: GoogleFonts.krub(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2B1F17),
            ),
          ),
          const Spacer(),
          Obx(() {
            final selectedCount = controller.cartItems
                .where((i) => i.isSelected)
                .length;
            if (selectedCount == 0) return const SizedBox.shrink();
            return TextButton(
              onPressed: () => controller.removeSelectedItems(),
              child: Text(
                'ลบรายการที่เลือก ($selectedCount)',
                style: GoogleFonts.krub(
                  color: const Color(0xFFC62828),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
