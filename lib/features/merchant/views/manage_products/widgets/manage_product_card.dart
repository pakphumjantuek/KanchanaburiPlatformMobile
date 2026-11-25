import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/app/routes/app_routes.dart';
import 'package:projecte/features/shops/models/product_model.dart';
import 'package:projecte/features/merchant/controllers/manage_products_controller.dart';
import 'package:projecte/features/merchant/theme/merchant_colors.dart';

String formatCurrency(double amount) {
  final str = amount.toStringAsFixed(2);
  final parts = str.split('.');
  final intPart = parts[0].replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (Match m) => '${m[1]},',
  );
  return '฿$intPart';
}

class ManageProductCard extends StatelessWidget {
  const ManageProductCard({
    super.key,
    required this.controller,
    required this.product,
  });

  final ManageProductsController controller;
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final isLowStock = product.quantity <= 5 && product.quantity > 0;
    final isOutOfStock = product.quantity <= 0;

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isOutOfStock
                ? const Color(0xFFFECDD3)
                : isLowStock
                    ? const Color(0xFFFDE68A)
                    : MerchantColors.border,
            width: (isOutOfStock || isLowStock) ? 1.2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: MerchantColors.primaryDark.withValues(alpha: 0.04),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Product Thumbnail Image
            Stack(
              children: [
                Container(
                  width: 82,
                  height: 82,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: (product.imageUrl != null && product.imageUrl!.isNotEmpty)
                        ? Image.network(
                            product.imageUrl!,
                            width: 82,
                            height: 82,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Container(
                              color: const Color(0xFFF1F5F9),
                              child: const Icon(
                                Icons.broken_image_rounded,
                                color: Color(0xFF94A3B8),
                                size: 30,
                              ),
                            ),
                          )
                        : Container(
                            color: MerchantColors.successBg,
                            child: const Icon(
                              Icons.inventory_2_rounded,
                              color: MerchantColors.primary,
                              size: 34,
                            ),
                          ),
                  ),
                ),
                if (isOutOfStock)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.62),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          'หมดสต็อก',
                          style: GoogleFonts.krub(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 13),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: GoogleFonts.krub(
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                      color: MerchantColors.textPrimary,
                      height: 1.25,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Price Tag
                  Text(
                    formatCurrency(product.price),
                    style: GoogleFonts.krub(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w800,
                      color: MerchantColors.primary,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Badges Row (Stock & Status)
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      _buildStockBadge(product.quantity),
                      _buildStatusBadge(product.status),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Action Buttons (Edit, Promo, Delete)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () async {
                    final result = await Get.toNamed(
                      AppRoutes.myShopProductForm,
                      arguments: product,
                    );
                    if (result == true) controller.loadProducts();
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: MerchantColors.primary,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: MerchantColors.primary.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.edit_rounded,
                          size: 13,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'แก้ไข',
                          style: GoogleFonts.krub(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                InkWell(
                  onTap: () => Get.toNamed(
                    AppRoutes.myShopProductDeals,
                    arguments: product,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: MerchantColors.warningBg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFFDE68A)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.local_fire_department_rounded,
                          size: 13,
                          color: Color(0xFFD97706),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          'โปรโมชัน',
                          style: GoogleFonts.krub(
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFD97706),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                InkWell(
                  onTap: () => controller.confirmDeleteProduct(product),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: MerchantColors.errorBg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFFECDD3)),
                    ),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      color: MerchantColors.error,
                      size: 15,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockBadge(int quantity) {
    Color bg = MerchantColors.successBg;
    Color fg = MerchantColors.primary;
    String text = 'คงเหลือ: $quantity ชิ้น';

    if (quantity <= 0) {
      bg = MerchantColors.errorBg;
      fg = MerchantColors.error;
      text = 'หมดสต็อก';
    } else if (quantity <= 5) {
      bg = MerchantColors.warningBg;
      fg = MerchantColors.warning;
      text = 'สต็อกต่ำ ($quantity)';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        text,
        style: GoogleFonts.krub(
          fontSize: 10.5,
          fontWeight: FontWeight.bold,
          color: fg,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final isActive = status.toLowerCase() == 'active';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
      decoration: BoxDecoration(
        color: isActive ? MerchantColors.success : const Color(0xFF64748B),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        isActive ? 'วางขาย' : 'ปิดการขาย',
        style: GoogleFonts.krub(
          fontSize: 10.5,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
