import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../shops/models/shop_model.dart';
import '../controllers/content_detail_controller.dart';
import 'detail_ui.dart';

/// Community shops linked to this place.
class ContentShopSection extends GetView<ContentDetailController> {
  const ContentShopSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final shops = controller.relatedShops;
      if (shops.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DetailDivider(),
          const DetailSectionTitle(title: 'ร้านค้าชุมชนที่นี่'),
          if (shops.length == 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _ShopTile(shop: shops.first),
            )
          else
            SizedBox(
              height: 92,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: shops.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (_, i) =>
                    SizedBox(width: 290, child: _ShopTile(shop: shops[i])),
              ),
            ),
        ],
      );
    });
  }
}

class _ShopTile extends StatelessWidget {
  final ShopModel shop;
  const _ShopTile({required this.shop});

  @override
  Widget build(BuildContext context) {
    final open = shop.isOpenNow;
    final hours = (shop.openingTime != null && shop.closingTime != null)
        ? '${shop.openingTime} - ${shop.closingTime} น.'
        : null;

    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: DetailColors.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Get.toNamed(
          AppRoutes.shopDetail.replaceFirst(':id', shop.id),
          arguments: shop,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 66,
                  height: 66,
                  child: DetailImage(
                    url: shop.coverImageUrl,
                    placeholderIcon: Icons.storefront_rounded,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shop.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: DetailColors.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      [
                        shop.categoryName ?? 'ร้านค้าชุมชน',
                        if (shop.districtName?.isNotEmpty ?? false)
                          'อ.${shop.districtName}',
                      ].join(' · '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: DetailColors.muted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: open
                                ? const Color(0xFF16A34A)
                                : DetailColors.muted,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            [open ? 'เปิดอยู่' : 'ปิดแล้ว', ?hours].join(' · '),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                              color: open
                                  ? const Color(0xFF16A34A)
                                  : DetailColors.muted,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: DetailColors.muted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
