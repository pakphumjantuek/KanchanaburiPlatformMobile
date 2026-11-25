import 'package:flutter/material.dart';
import 'home_network_image.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import 'home_section_header.dart';
import '../widgets/home_colors.dart';

class HomeShopsSection extends GetView<HomeController> {
  const HomeShopsSection({super.key});

  Widget _buildShopPlaceholder() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2B1F17), Color(0xFF4A3427)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.storefront_rounded,
          color: Color(0xFFFFCC80),
          size: 40,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final list = controller.shops;
      if (list.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =========================
          // HEADER ROW
          // =========================
          HomeSectionHeader(
            title: 'ร้านค้าชุมชนแนะนำ',
            subtitle: 'สนับสนุนสินค้าและผลิตภัณฑ์ตรงจากชาวบ้าน',
            onSeeAll: () => openMainTab(1, '/shops'),
          ),
          const SizedBox(height: 14),

          // =========================
          // HORIZONTAL SHOPS CARDS
          // =========================
          SizedBox(
            height: 235,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: list.length,
              separatorBuilder: (ctx, idx) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final shop = list[index];
                final hasImage =
                    shop.coverImageUrl != null &&
                    shop.coverImageUrl!.isNotEmpty;

                return Container(
                  width: 210,
                  decoration: BoxDecoration(
                    color: HomeColors.cardWhite,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Get.toNamed('/shops/${shop.id}'),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1. Cover Image Section
                            Stack(
                              children: [
                                SizedBox(
                                  height: 110,
                                  width: double.infinity,
                                  child: hasImage
                                      ? HomeNetworkImage(
                                          url: shop.coverImageUrl!,
                                          placeholder: _buildShopPlaceholder(),
                                        )
                                      : _buildShopPlaceholder(),
                                ),

                                // Status Open/Closed Badge (Top Right)
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: shop.isOpenNow
                                          ? const Color(0xFF059669)
                                          : const Color(0xFF64748B),
                                      borderRadius: BorderRadius.circular(14),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 6,
                                          height: 6,
                                          decoration: BoxDecoration(
                                            color: shop.isOpenNow
                                                ? const Color(0xFF6EE7B7)
                                                : const Color(0xFFCBD5E1),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          shop.isOpenNow
                                              ? 'เปิดอยู่'
                                              : 'ปิดแล้ว',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // 2. Details Section
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  12,
                                  10,
                                  12,
                                  10,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Shop Name
                                    Text(
                                      shop.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: HomeColors.textBlack,
                                      ),
                                    ),

                                    // Location Pill
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: HomeColors.brandSoft,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: HomeColors.brandPrimary
                                              .withValues(alpha: 0.2),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.location_on_rounded,
                                            size: 13,
                                            color: HomeColors.brandPrimary,
                                          ),
                                          const SizedBox(width: 3),
                                          Flexible(
                                            child: Text(
                                              shop.districtName ?? 'กาญจนบุรี',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 11.5,
                                                fontWeight: FontWeight.w600,
                                                color: HomeColors.brandPrimary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Action Text
                                    const Row(
                                      children: [
                                        Text(
                                          'เยี่ยมชมร้านค้า',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: HomeColors.textMuted,
                                          ),
                                        ),
                                        SizedBox(width: 4),
                                        Icon(
                                          Icons.arrow_forward_rounded,
                                          size: 14,
                                          color: HomeColors.brandPrimary,
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
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
