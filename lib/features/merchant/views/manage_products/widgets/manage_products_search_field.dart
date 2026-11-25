import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/merchant/controllers/manage_products_controller.dart';
import 'package:projecte/features/merchant/theme/merchant_colors.dart';

class ManageProductsSearchField extends StatelessWidget {
  const ManageProductsSearchField({super.key, required this.controller});

  final ManageProductsController controller;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Input Field
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: MerchantColors.border),
                boxShadow: [
                  BoxShadow(
                    color: MerchantColors.primaryDark.withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Obx(() {
                final hasText = controller.searchQuery.value.isNotEmpty;

                return TextField(
                  onChanged: (val) => controller.searchQuery.value = val,
                  style: GoogleFonts.krub(
                    fontSize: 14,
                    color: MerchantColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'ค้นหาชื่อสินค้า รายละเอียด หรือหมวดหมู่...',
                    hintStyle: GoogleFonts.krub(
                      color: MerchantColors.textMuted,
                      fontSize: 13,
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: MerchantColors.primary,
                      size: 22,
                    ),
                    suffixIcon: hasText
                        ? IconButton(
                            icon: const Icon(
                              Icons.close_rounded,
                              size: 18,
                              color: MerchantColors.textSecondary,
                            ),
                            onPressed: () => controller.searchQuery.value = '',
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 13,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: MerchantColors.primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 10),

            // Quick Filter Chips + Results Count Row
            Obx(() {
              final activeFilter = controller.selectedFilter.value;
              final filteredCount = controller.filteredProducts.length;

              return Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          _buildFilterChip(
                            label: 'ทั้งหมด',
                            count: controller.totalCount,
                            filterKey: 'all',
                            isSelected: activeFilter == 'all',
                          ),
                          const SizedBox(width: 6),
                          _buildFilterChip(
                            label: 'พร้อมขาย',
                            count: controller.activeCount,
                            filterKey: 'active',
                            isSelected: activeFilter == 'active',
                          ),
                          const SizedBox(width: 6),
                          _buildFilterChip(
                            label: 'สต็อกต่ำ',
                            count: controller.lowStockCount,
                            filterKey: 'lowStock',
                            isSelected: activeFilter == 'lowStock',
                            badgeColor: const Color(0xFFD97706),
                          ),
                          const SizedBox(width: 6),
                          _buildFilterChip(
                            label: 'สินค้าหมด',
                            count: controller.outOfStockCount,
                            filterKey: 'outOfStock',
                            isSelected: activeFilter == 'outOfStock',
                            badgeColor: const Color(0xFFE11D48),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: MerchantColors.successBg,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFA7F3D0)),
                    ),
                    child: Text(
                      'พบ $filteredCount รายการ',
                      style: GoogleFonts.krub(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: MerchantColors.primaryDark,
                      ),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required int count,
    required String filterKey,
    required bool isSelected,
    Color? badgeColor,
  }) {
    return InkWell(
      onTap: () => controller.setFilter(filterKey),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected
              ? MerchantColors.primary
              : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? MerchantColors.primary : MerchantColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.krub(
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : MerchantColors.textPrimary,
              ),
            ),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.25)
                    : (badgeColor?.withValues(alpha: 0.15) ?? const Color(0xFFE2E8F0)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: GoogleFonts.krub(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? Colors.white
                      : (badgeColor ?? MerchantColors.textSecondary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
