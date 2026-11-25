import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecte/app/routes/app_routes.dart';
import 'package:projecte/features/cart/controllers/cart_controller.dart';
import 'package:projecte/features/content_detail/widgets/detail_ui.dart';
import 'package:projecte/features/shops/models/product_model.dart';

/// Product grid with in-shop search and sort (shown for larger catalogs).
class ShopDetailProductsSection extends StatelessWidget {
  final List<ProductModel> products;
  final int totalCount;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final String sortOption;
  final ValueChanged<String> onSortChanged;

  const ShopDetailProductsSection({
    super.key,
    required this.products,
    required this.totalCount,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.sortOption,
    required this.onSortChanged,
  });

  static const _sorts = {
    'popular': 'แนะนำ',
    'price_asc': 'ราคาต่ำ-สูง',
    'price_desc': 'ราคาสูง-ต่ำ',
  };

  @override
  Widget build(BuildContext context) {
    if (totalCount == 0) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DetailSectionTitle(title: 'สินค้าในร้าน'),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'ร้านนี้ยังไม่มีสินค้าออนไลน์',
              style: TextStyle(fontSize: 14, color: DetailColors.muted),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DetailSectionTitle(title: 'สินค้าในร้าน · $totalCount รายการ'),
        if (totalCount > 6) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: 'ค้นหาสินค้าในร้านนี้',
                hintStyle: const TextStyle(
                  fontSize: 14,
                  color: DetailColors.muted,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: DetailColors.muted,
                ),
                isDense: true,
                filled: true,
                fillColor: DetailColors.canvas,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
        SizedBox(
          height: 34,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              for (final e in _sorts.entries) ...[
                ChoiceChip(
                  label: Text(e.value),
                  selected: sortOption == e.key,
                  onSelected: (_) => onSortChanged(e.key),
                  showCheckmark: false,
                  visualDensity: VisualDensity.compact,
                  selectedColor: DetailColors.brandSoft,
                  backgroundColor: Colors.white,
                  side: BorderSide(
                    color: sortOption == e.key
                        ? DetailColors.brand
                        : DetailColors.line,
                  ),
                  shape: const StadiumBorder(),
                  labelStyle: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: sortOption == e.key
                        ? DetailColors.brand
                        : DetailColors.body,
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ],
          ),
        ),
        const SizedBox(height: 14),
        if (products.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'ไม่พบสินค้า "$searchQuery" ในร้านนี้',
              style: const TextStyle(fontSize: 14, color: DetailColors.muted),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 18,
              crossAxisSpacing: 14,
              mainAxisExtent: 222,
            ),
            itemCount: products.length,
            itemBuilder: (_, i) => _ProductTile(product: products[i]),
          ),
      ],
    );
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
    final soldOut = product.quantity <= 0;

    return InkWell(
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
              height: 150,
              width: double.infinity,
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
                      child: _Badge(
                        text:
                            '-${((1 - product.dealPrice / product.price) * 100).round()}%',
                        color: const Color(0xFFE5484D),
                      ),
                    ),
                  if (soldOut)
                    const ColoredBox(
                      color: Color(0x99FFFFFF),
                      child: Center(
                        child: _Badge(
                          text: 'สินค้าหมด',
                          color: DetailColors.ink,
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
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '฿${price.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                          color: hasDeal
                              ? const Color(0xFFE5484D)
                              : DetailColors.brand,
                        ),
                      ),
                      if (hasDeal)
                        TextSpan(
                          text: '  ฿${product.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: DetailColors.muted,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (!soldOut)
                Material(
                  color: DetailColors.brandSoft,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => Get.find<CartController>().addToCart(product),
                    child: const Padding(
                      padding: EdgeInsets.all(7),
                      child: Icon(
                        Icons.add_shopping_cart_rounded,
                        size: 17,
                        color: DetailColors.brand,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  const _Badge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
