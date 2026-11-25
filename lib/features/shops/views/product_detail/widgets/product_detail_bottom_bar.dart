import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecte/app/theme/app_colors.dart';
import 'package:projecte/features/shops/controllers/product_detail_controller.dart';

class ProductDetailBottomBar extends GetView<ProductDetailController> {
  const ProductDetailBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final product = controller.product.value;
      if (product == null) return const SizedBox.shrink();

      final inStock = product.quantity > 0;
      return Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.border, width: 1)),
          boxShadow: [
            BoxShadow(
              color: Color(0x100D2B22),
              blurRadius: 14,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              // Favorite Button
              Obx(
                () => Material(
                  color: const Color(0xFFF3F7F5),
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: controller.toggleFavorite,
                    child: Container(
                      width: 48,
                      height: 48,
                      alignment: Alignment.center,
                      child: Icon(
                        controller.isFavorite.value
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: controller.isFavorite.value
                            ? AppColors.error
                            : AppColors.textSecondary,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Add To Cart Button
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: inStock ? controller.addToCart : null,
                  icon: const Icon(
                    Icons.add_shopping_cart_rounded,
                    size: 19,
                  ),
                  label: const Text(
                    'ใส่ตะกร้า',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14.5,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                    minimumSize: const Size(0, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // Buy Now Button
              Expanded(
                flex: 1,
                child: ElevatedButton.icon(
                  onPressed: inStock ? controller.buyNow : null,
                  icon: const Icon(
                    Icons.bolt_rounded,
                    size: 20,
                    color: AppColors.gold,
                  ),
                  label: Text(
                    inStock ? 'ซื้อทันที' : 'สินค้าหมด',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 14.5,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: inStock
                        ? AppColors.primaryDark
                        : Colors.grey[400],
                    elevation: 0,
                    minimumSize: const Size(0, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
