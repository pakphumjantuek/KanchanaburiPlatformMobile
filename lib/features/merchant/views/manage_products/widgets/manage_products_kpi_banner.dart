import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/merchant/controllers/manage_products_controller.dart';
import 'package:projecte/features/merchant/theme/merchant_colors.dart';

class ManageProductsKpiBanner extends StatelessWidget {
  const ManageProductsKpiBanner({super.key, required this.controller});

  final ManageProductsController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: MerchantColors.heroGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shop Profile Header
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.25),
                    ),
                  ),
                  child: const Icon(
                    Icons.inventory_2_rounded,
                    color: Color(0xFFFDE68A),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => Text(
                            controller.myShop.value?.shopName ??
                                'คลังสินค้าประจำร้านค้า',
                            style: GoogleFonts.krub(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )),
                      const SizedBox(height: 2),
                      Text(
                        'จัดการสต็อกสินค้า อัปเดตราคา และจัดโปรโมชัน',
                        style: GoogleFonts.krub(
                          fontSize: 11.5,
                          color: const Color(0xFFA7F3D0).withValues(alpha: 0.9),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Interactive Metric KPI Cards
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Obx(() {
              final total = controller.totalCount;
              final active = controller.activeCount;
              final lowStock = controller.lowStockCount;
              final outOfStock = controller.outOfStockCount;
              final currentFilter = controller.selectedFilter.value;

              return Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      title: 'ทั้งหมด',
                      value: '$total',
                      subText: 'รายการคลัง',
                      icon: Icons.all_inbox_rounded,
                      iconColor: Colors.white,
                      isSelected: currentFilter == 'all',
                      onTap: () => controller.setFilter('all'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildMetricCard(
                      title: 'พร้อมขาย',
                      value: '$active',
                      subText: 'สถานะปกติ',
                      icon: Icons.check_circle_rounded,
                      iconColor: const Color(0xFF34D399),
                      isSelected: currentFilter == 'active',
                      onTap: () => controller.setFilter('active'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildMetricCard(
                      title: 'สต็อกเตือน',
                      value: '$lowStock',
                      subText: lowStock > 0 ? '≤ 5 ชิ้น' : 'ไม่มีค้าง',
                      icon: Icons.warning_amber_rounded,
                      iconColor: const Color(0xFFFBBF24),
                      isSelected: currentFilter == 'lowStock',
                      onTap: () => controller.setFilter('lowStock'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildMetricCard(
                      title: 'สินค้าหมด',
                      value: '$outOfStock',
                      subText: outOfStock > 0 ? 'ต้องเติมสต็อก' : 'ไม่มีหมด',
                      icon: Icons.remove_shopping_cart_rounded,
                      iconColor: const Color(0xFFFB7185),
                      isSelected: currentFilter == 'outOfStock',
                      onTap: () => controller.setFilter('outOfStock'),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subText,
    required IconData icon,
    required Color iconColor,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.white.withValues(alpha: 0.22)
                : Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF34D399).withValues(alpha: 0.95)
                  : Colors.white.withValues(alpha: 0.15),
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF34D399).withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.krub(
                        fontSize: 10,
                        color: Colors.white.withValues(alpha: 0.88),
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(icon, size: 13, color: iconColor),
                ],
              ),
              const SizedBox(height: 3),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  style: GoogleFonts.krub(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: -0.4,
                  ),
                  maxLines: 1,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                subText,
                style: GoogleFonts.krub(
                  fontSize: 9,
                  color: isSelected
                      ? const Color(0xFFD1FAE5)
                      : Colors.white.withValues(alpha: 0.65),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
