import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecte/app/theme/app_colors.dart';
import 'package:projecte/features/shops/controllers/product_detail_controller.dart';
import 'package:projecte/features/shops/models/product_model.dart';
import 'package:projecte/features/shops/models/shop_review_model.dart';

class ProductDetailNavTabs extends GetView<ProductDetailController> {
  const ProductDetailNavTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Obx(() {
        final currentTab = controller.activeTab.value;
        final reviewCount = controller.shopReviews.length;

        return Row(
          children: [
            Expanded(
              child: _tabButton(
                label: 'รายละเอียดสินค้า',
                isSelected: currentTab == 'details',
                onTap: () => controller.changeTab('details'),
              ),
            ),
            Expanded(
              child: _tabButton(
                label: 'รีวิวจากผู้ซื้อ ($reviewCount)',
                isSelected: currentTab == 'reviews',
                onTap: () => controller.changeTab('reviews'),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _tabButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: 2.5,
              ),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProductDetailsTabContent extends StatelessWidget {
  final ProductModel product;

  const ProductDetailsTabContent({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final hasDesc =
        product.description != null && product.description!.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.description_outlined,
                size: 18,
                color: AppColors.primary,
              ),
              SizedBox(width: 8),
              Text(
                'ข้อมูลและรายละเอียดสินค้า',
                style: TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            hasDesc
                ? product.description!
                : 'ไม่มีรายละเอียดเพิ่มเติมสำหรับสินค้าชิ้นนี้',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF334155),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),

          // Specification Tags Box
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAF9),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                _specRow('แหล่งกำเนิด', 'ผลิตภัณฑ์ชุมชน จังหวัดกาญจนบุรี'),
                const Divider(color: AppColors.border, height: 18),
                if (product.shopName != null) ...[
                  const Divider(color: AppColors.border, height: 18),
                  _specRow('ร้านค้า', product.shopName!),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _specRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class ProductReviewsTabContent extends StatelessWidget {
  final List<ShopReviewModel> reviews;

  const ProductReviewsTabContent({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 42, horizontal: 20),
        color: Colors.white,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFE8F3EE),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.rate_review_outlined,
                size: 38,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'ยังไม่มีรีวิวสำหรับสินค้านี้',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'ร่วมสนับสนุนสินค้าชุมชน และเป็นคนแรกที่รีวิวสินค้านี้',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    final averageRating =
        reviews.fold<double>(0, (sum, review) => sum + review.rating) /
            reviews.length;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Review Score Summary Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFFDE68A)),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          averageRating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF92400E),
                          ),
                        ),
                        const Text(
                          ' / 5.0',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFB45309),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          index < averageRating.floor()
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          size: 16,
                          color: AppColors.gold,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  'จากทั้งหมด ${reviews.length} รีวิว',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF92400E),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Review Items
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: reviews.length,
            separatorBuilder: (_, _) =>
                const Divider(color: AppColors.border, height: 24),
            itemBuilder: (context, index) {
              final r = reviews[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: const Color(0xFFE8F3EE),
                        child: Text(
                          r.userName.isNotEmpty
                              ? r.userName[0].toUpperCase()
                              : 'U',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              r.userName,
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Row(
                              children: List.generate(
                                5,
                                (starIdx) => Icon(
                                  starIdx < r.rating
                                      ? Icons.star_rounded
                                      : Icons.star_border_rounded,
                                  size: 14,
                                  color: AppColors.gold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${r.createdAt.day}/${r.createdAt.month}/${r.createdAt.year}',
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  if (r.comment.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      r.comment,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF334155),
                        height: 1.45,
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
