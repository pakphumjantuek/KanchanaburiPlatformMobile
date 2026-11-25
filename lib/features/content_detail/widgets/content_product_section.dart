import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../shops/models/product_model.dart';
import '../controllers/content_detail_controller.dart';
import 'detail_ui.dart';

/// Local products related to this place, as a horizontal shelf.
class ContentProductSection extends GetView<ContentDetailController> {
  const ContentProductSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final products = controller.relatedProducts;
      if (products.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DetailDivider(),
          const DetailSectionTitle(title: 'ของดีจากที่นี่'),
          SizedBox(
            height: 222,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: products.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (_, i) => _ProductTile(product: products[i]),
            ),
          ),
        ],
      );
    });
  }
}

class _ProductTile extends StatelessWidget {
  final ProductModel product;
  const _ProductTile({required this.product});

  @override
  Widget build(BuildContext context) {
    final deal = product.activeDeal;
    final hasDeal =
        deal != null && !deal.isExpired && deal.availableQuantity > 0;
    final price = hasDeal ? product.dealPrice : product.price;

    return SizedBox(
      width: 148,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Get.toNamed(
          AppRoutes.productDetail.replaceFirst(':id', product.id),
          arguments: product,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                width: 148,
                height: 148,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    DetailImage(
                      url: product.imageUrl,
                      placeholderIcon: Icons.shopping_bag_outlined,
                    ),
                    if (hasDeal && product.price > 0)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE5484D),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '-${((1 - product.dealPrice / product.price) * 100).round()}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: DetailColors.ink,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '฿${price.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: hasDeal
                        ? const Color(0xFFE5484D)
                        : DetailColors.brand,
                  ),
                ),
                if (hasDeal) ...[
                  const SizedBox(width: 5),
                  Text(
                    '฿${product.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: DetailColors.muted,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
