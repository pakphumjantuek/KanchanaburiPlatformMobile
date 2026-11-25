import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/cart_controller.dart';

void showConfirmClearCartDialog(BuildContext context, CartController controller) {
  Get.dialog(
    AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: Text(
        'ยืนยันการล้างตะกร้าสินค้า',
        style: GoogleFonts.krub(fontWeight: FontWeight.bold),
      ),
      content: Text(
        'คุณต้องการลบสินค้าทั้งหมดออกจากตะกร้าใช่หรือไม่?',
        style: GoogleFonts.krub(),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text(
            'ยกเลิก',
            style: GoogleFonts.krub(color: Colors.grey[700]),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            controller.clearCart();
            Get.back();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFC62828),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            'ล้างตะกร้า',
            style: GoogleFonts.krub(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}
