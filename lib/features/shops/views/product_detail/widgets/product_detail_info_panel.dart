import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecte/app/theme/app_colors.dart';
import 'package:projecte/features/shops/controllers/product_detail_controller.dart';
import 'package:projecte/features/shops/models/product_model.dart';
import 'package:projecte/features/shops/models/shop_model.dart';

class ProductDetailInfoPanel extends GetView<ProductDetailController> {
  const ProductDetailInfoPanel({super.key, required this.product, this.shop});

  final ProductModel product;
  final ShopModel? shop;

  @override
  Widget build(BuildContext context) {
    final deal = product.activeDeal;
    final hasDeal =
        deal != null && !deal.isExpired && deal.availableQuantity > 0;
    final inStock = product.quantity > 0;
    final discount = product.price <= 0
        ? 0
        : ((product.price - product.dealPrice) / product.price * 100).round();
    final reviews = controller.shopReviews;
    final averageRating = reviews.isEmpty
        ? 0.0
        : reviews.fold<double>(0, (sum, review) => sum + review.rating) /
              reviews.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category / Origin Tag
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F3EE),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.local_offer_rounded,
                size: 13,
                color: AppColors.primary,
              ),
              const SizedBox(width: 5),
              Text(
                shop?.categoryName?.isNotEmpty == true
                    ? 'สินค้าชุมชน  •  ${shop!.categoryName}'
                    : 'สินค้าชุมชนเมืองกาญจน์',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Product Name
        Text(
          product.name,
          style: const TextStyle(
            fontSize: 22,
            height: 1.3,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 10),

        // Ratings & Quality Guarantee Row
        Row(
          children: [
            // Rating stars
            if (reviews.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF9E6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 16,
                      color: AppColors.gold,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      averageRating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF8A6200),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '(${reviews.length} รีวิว)',
                style: const TextStyle(
                  fontSize: 12.5,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 3,
                height: 3,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFCBD5E1),
                ),
              ),
              const SizedBox(width: 8),
            ],

            // Verified Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F7F5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFD8E5DF)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.verified_rounded,
                    size: 13,
                    color: AppColors.secondary,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'ของแท้จากแหล่งผลิต',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Price Row Card
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFFAFCFA),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Price
              Text(
                '฿${(hasDeal ? product.dealPrice : product.price).toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: AppColors.accent,
                  height: 1,
                  letterSpacing: -0.5,
                ),
              ),

              if (hasDeal) ...[
                const SizedBox(width: 10),
                Text(
                  '฿${product.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF94A3B8),
                    decoration: TextDecoration.lineThrough,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDEEE9),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: AppColors.accent.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    '-$discount%',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ],

              const Spacer(),

              // Stock Status Tag
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: inStock
                          ? const Color(0xFF1B9966)
                          : AppColors.error,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    inStock ? 'คงเหลือ ${product.quantity} ชิ้น' : 'สินค้าหมด',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: inStock
                          ? const Color(0xFF1B9966)
                          : AppColors.error,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Quantity Stepper Row
        if (inStock)
          Row(
            children: [
              const Text(
                'จำนวนที่ต้องการสั่งซื้อ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    _quantityButton(
                      icon: Icons.remove_rounded,
                      onTap: controller.decrementQuantity,
                    ),
                    Container(
                      constraints: const BoxConstraints(minWidth: 42),
                      alignment: Alignment.center,
                      child: Obx(
                        () => Text(
                          '${controller.quantity.value}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    _quantityButton(
                      icon: Icons.add_rounded,
                      onTap: controller.incrementQuantity,
                    ),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _quantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, size: 18, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}
