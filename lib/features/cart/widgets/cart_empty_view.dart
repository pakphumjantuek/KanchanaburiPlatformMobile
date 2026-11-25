import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/routes/app_routes.dart';
import '../../../shared/widgets/empty_widget.dart';

class CartEmptyView extends StatelessWidget {
  const CartEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const EmptyWidget(
            title: 'ตะกร้าสินค้ายังว่างอยู่',
            message:
                'คุณยังไม่ได้เพิ่มสินค้าใดๆ ลงในตะกร้า\nลองเลือกดูสินค้าโอทอปและของฝากกาญจนบุรีได้เลย',
            icon: Icons.shopping_cart_outlined,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              Get.toNamed(AppRoutes.shops);
            },
            icon: const Icon(Icons.storefront_rounded, size: 20),
            label: Text(
              'ไปเลือกซื้อสินค้า',
              style: GoogleFonts.krub(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD96C2C),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 2,
            ),
          ),
        ],
      ),
    );
  }
}
