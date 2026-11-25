import 'package:flutter/material.dart';
import 'package:projecte/features/content_detail/widgets/detail_ui.dart';
import 'package:projecte/features/shops/models/shop_model.dart';

/// Logo, name, category/location and a stats strip under the banner.
class ShopDetailHeaderCard extends StatelessWidget {
  final ShopModel shop;
  final double rating;
  final int reviewCount;
  final int productCount;
  final VoidCallback? onRatingTap;
  final VoidCallback? onProductsTap;

  const ShopDetailHeaderCard({
    super.key,
    required this.shop,
    required this.rating,
    required this.reviewCount,
    required this.productCount,
    this.onRatingTap,
    this.onProductsTap,
  });

  @override
  Widget build(BuildContext context) {
    final open = shop.isOpenNow;
    final hasHours = shop.openingTime != null && shop.closingTime != null;
    final meta = [
      shop.categoryName ?? 'ร้านค้าชุมชน',
      if (shop.districtName?.isNotEmpty ?? false) 'อ.${shop.districtName}',
    ].join(' · ');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: DetailColors.line),
                ),
                child: ClipOval(
                  child: DetailImage(
                    url: shop.coverImageUrl,
                    placeholderIcon: Icons.storefront_rounded,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shop.name,
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                        color: DetailColors.ink,
                        height: 1.3,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      meta,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: DetailColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: DetailColors.canvas,
              borderRadius: BorderRadius.circular(16),
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  _Stat(
                    icon: Icons.star_rounded,
                    iconColor: DetailColors.star,
                    value: rating > 0 ? rating.toStringAsFixed(1) : 'ใหม่',
                    label: reviewCount > 0
                        ? '$reviewCount รีวิว'
                        : 'ยังไม่มีรีวิว',
                    onTap: onRatingTap,
                  ),
                  const _StatDivider(),
                  _Stat(
                    icon: Icons.shopping_bag_outlined,
                    value: '$productCount',
                    label: 'สินค้า',
                    onTap: onProductsTap,
                  ),
                  const _StatDivider(),
                  _Stat(
                    icon: Icons.circle,
                    iconSize: 9,
                    iconColor: open
                        ? const Color(0xFF16A34A)
                        : DetailColors.muted,
                    value: open ? 'เปิดอยู่' : 'ปิดแล้ว',
                    valueColor: open ? const Color(0xFF16A34A) : null,
                    label: hasHours
                        ? '${shop.openingTime} - ${shop.closingTime}'
                        : 'เวลาทำการ',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final Color iconColor;
  final String value;
  final Color? valueColor;
  final String label;
  final VoidCallback? onTap;

  const _Stat({
    required this.icon,
    required this.value,
    required this.label,
    this.iconSize = 15,
    this.iconColor = DetailColors.muted,
    this.valueColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: iconSize, color: iconColor),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: valueColor ?? DetailColors.ink,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11.5, color: DetailColors.muted),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return const VerticalDivider(
      width: 1,
      thickness: 1,
      indent: 4,
      endIndent: 4,
      color: DetailColors.line,
    );
  }
}
