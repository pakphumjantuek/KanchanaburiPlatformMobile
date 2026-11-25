import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecte/app/routes/app_routes.dart';
import 'package:projecte/features/cart/controllers/cart_controller.dart';
import 'package:projecte/features/shops/models/product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel item;
  final VoidCallback? onAddToCart;

  const ProductCard({super.key, required this.item, this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    final deal = item.activeDeal;
    final hasDeal =
        deal != null && !deal.isExpired && deal.availableQuantity > 0;
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.productDetail, arguments: item);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE0EAE6), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F382C).withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            AspectRatio(
              aspectRatio: 1,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                        ? Image.network(
                            item.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildPlaceholder(),
                          )
                        : _buildPlaceholder(),
                  ),
                  if (hasDeal)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE76F51),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          deal.label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Product Details Column
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(9, 7, 9, 7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D2B22),
                        height: 1.2,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: hasDeal
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '฿${item.dealPrice.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFFE76F51),
                                      ),
                                    ),
                                    Text(
                                      '฿${item.price.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  '฿${item.price.toStringAsFixed(0)}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFFE76F51),
                                  ),
                                ),
                        ),
                        InkWell(
                          onTap:
                              onAddToCart ??
                              () {
                                Get.find<CartController>().addToCart(item);
                              },
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF2A9D8F), Color(0xFF1B4D3E)],
                              ),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF2A9D8F,
                                  ).withValues(alpha: 0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.add_shopping_cart_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE76F51), Color(0xFFF4A261)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.shopping_bag_outlined,
          size: 38,
          color: Colors.white70,
        ),
      ),
    );
  }
}
