import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecte/app/routes/app_routes.dart';
import 'package:projecte/app/theme/app_colors.dart';
import 'package:projecte/features/shops/models/shop_model.dart';

class ProductDetailSellerCard extends StatelessWidget {
  const ProductDetailSellerCard({super.key, required this.shop});

  final ShopModel shop;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080D2B22),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => Get.toNamed(AppRoutes.shopDetail, arguments: shop),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                // Shop Avatar with verified badge
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: const Color(0xFFE8F3EE),
                      backgroundImage: shop.coverImageUrl?.isNotEmpty == true
                          ? NetworkImage(shop.coverImageUrl!)
                          : null,
                      child: shop.coverImageUrl?.isNotEmpty == true
                          ? null
                          : const Icon(
                              Icons.storefront_rounded,
                              color: AppColors.primary,
                              size: 26,
                            ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.verified_rounded,
                          size: 14,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 13),

                // Shop Information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shop.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          if (shop.districtName?.isNotEmpty == true) ...[
                            const Icon(
                              Icons.location_on_outlined,
                              size: 13,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              'อ.${shop.districtName}',
                              style: const TextStyle(
                                fontSize: 12.5,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              '•',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 6),
                          ],
                          Flexible(
                            child: Text(
                              shop.categoryName?.isNotEmpty == true
                                  ? shop.categoryName!
                                  : 'ร้านค้าชุมชน',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12.5,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),

                // Visit Shop Button Pill
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F3EE),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'ดูร้านค้า',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(width: 3),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 13,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
