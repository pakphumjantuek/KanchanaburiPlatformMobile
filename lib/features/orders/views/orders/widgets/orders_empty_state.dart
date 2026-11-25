import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/routes/app_routes.dart';

class OrdersEmptyState extends StatelessWidget {
  const OrdersEmptyState({super.key, required this.onRefresh});

  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: const Color(0xFFD96C2C),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 50),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9F2),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE8D9C9), width: 1.5),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD96C2C).withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.receipt_long_rounded,
                    size: 48,
                    color: Color(0xFFD96C2C),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'ยังไม่มีคำสั่งซื้อในหมวดหมู่นี้',
                  style: GoogleFonts.krub(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: const Color(0xFF332820),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'รายการคำสั่งซื้อสินค้าโอทอปและสินค้าชุมชนของคุณจะปรากฏที่นี่เมื่อมีคำสั่งซื้อตรงตามสถานะ',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.krub(
                    fontSize: 13,
                    color: const Color(0xFF786B62),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 22),
                ElevatedButton.icon(
                  onPressed: () => Get.offAllNamed(AppRoutes.initial),
                  icon: const Icon(Icons.shopping_bag_outlined, size: 18),
                  label: Text(
                    'เลือกซื้อสินค้าชุมชน',
                    style: GoogleFonts.krub(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD96C2C),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
