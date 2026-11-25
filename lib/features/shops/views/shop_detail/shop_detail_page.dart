import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecte/features/content_detail/widgets/detail_ui.dart';
import 'package:projecte/features/shops/controllers/shop_detail_controller.dart';
import 'package:projecte/features/shops/views/shop_detail/widgets/shop_detail_about_section.dart';
import 'package:projecte/features/shops/views/shop_detail/widgets/shop_detail_bottom_bar.dart';
import 'package:projecte/features/shops/views/shop_detail/widgets/shop_detail_content_section.dart';
import 'package:projecte/features/shops/views/shop_detail/widgets/shop_detail_hero.dart';
import 'package:projecte/features/shops/views/shop_detail/widgets/shop_detail_nav_tabs.dart';
import 'package:projecte/features/shops/views/shop_detail/widgets/shop_detail_products_section.dart';
import 'package:projecte/features/shops/views/shop_detail/widgets/shop_detail_reviews_section.dart';
import 'package:projecte/features/shops/views/shop_detail/widgets/shop_detail_skeleton.dart';
import 'package:projecte/features/shops/views/shop_detail/widgets/shop_detail_summary_card.dart';
import 'package:projecte/shared/widgets/error_widget.dart';

class ShopDetailPage extends StatefulWidget {
  const ShopDetailPage({super.key});

  @override
  State<ShopDetailPage> createState() => _ShopDetailPageState();
}

class _ShopDetailPageState extends State<ShopDetailPage> {
  final controller = Get.find<ShopDetailController>();

  // Section anchors for the pinned shortcut bar, in display order.
  final _productsKey = GlobalKey();
  final _storiesKey = GlobalKey();
  final _aboutKey = GlobalKey();
  final _reviewsKey = GlobalKey();
  int _activeSection = 0;

  Future<void> _scrollTo(GlobalKey key, int index) async {
    setState(() => _activeSection = index);
    final ctx = key.currentContext;
    if (ctx == null) return;
    await Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
      // Land just under the pinned app bar + shortcut bar.
      alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
      alignment: 0.12,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final shop = controller.shop.value;

      if (controller.isLoading.value && shop == null) {
        return const ShopDetailSkeleton();
      }
      if (controller.isError.value || shop == null) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            foregroundColor: DetailColors.ink,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
          ),
          body: Center(
            child: CustomErrorWidget(
              message: controller.errorMessage.value.isNotEmpty
                  ? controller.errorMessage.value
                  : 'ไม่สามารถโหลดข้อมูลร้านค้าได้',
              onRetry: () {
                final args = Get.arguments;
                final id = args is String
                    ? args
                    : (args?.id as String?) ?? Get.parameters['id'];
                if (id != null) controller.loadShopDetailAndProducts(id);
              },
            ),
          ),
        );
      }

      final hasPhone = shop.phone?.trim().isNotEmpty ?? false;
      final sections = [
        (_productsKey, ShopNavItem('สินค้า', controller.products.length)),
        if (controller.shopContents.isNotEmpty)
          (
            _storiesKey,
            ShopNavItem('เรื่องราว', controller.shopContents.length),
          ),
        (_aboutKey, const ShopNavItem('ข้อมูลร้าน')),
        (_reviewsKey, ShopNavItem('รีวิว', controller.reviews.length)),
      ];
      final active = _activeSection.clamp(0, sections.length - 1);

      return Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: ShopDetailBottomBar(
          onCall: hasPhone ? () => controller.makePhoneCall(shop.phone!) : null,
          onDirections: controller.openDirections,
        ),
        body: RefreshIndicator(
          onRefresh: () => controller.loadShopDetailAndProducts(shop.id),
          color: DetailColors.brand,
          edgeOffset: MediaQuery.paddingOf(context).top + kToolbarHeight,
          child: CustomScrollView(
            slivers: [
              ShopDetailHero(shop: shop, onShare: controller.shareShop),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ShopDetailHeaderCard(
                    shop: shop,
                    rating: controller.averageRating,
                    reviewCount: controller.reviewCount,
                    productCount: controller.products.length,
                    onRatingTap: () =>
                        _scrollTo(_reviewsKey, sections.length - 1),
                    onProductsTap: () => _scrollTo(_productsKey, 0),
                  ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: ShopDetailNavTabs(
                  items: [for (final s in sections) s.$2],
                  activeIndex: active,
                  onSelected: (i) => _scrollTo(sections[i].$1, i),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    KeyedSubtree(
                      key: _productsKey,
                      child: ShopDetailProductsSection(
                        products: controller.filteredProducts,
                        totalCount: controller.products.length,
                        searchQuery: controller.productSearchQuery.value,
                        onSearchChanged: controller.setSearchQuery,
                        sortOption: controller.productSortOption.value,
                        onSortChanged: controller.setSortOption,
                      ),
                    ),
                    if (controller.shopContents.isNotEmpty) ...[
                      const DetailDivider(),
                      KeyedSubtree(
                        key: _storiesKey,
                        child: ShopDetailContentSection(
                          contents: controller.shopContents,
                        ),
                      ),
                    ],
                    const DetailDivider(),
                    KeyedSubtree(
                      key: _aboutKey,
                      child: ShopDetailAboutSection(
                        shop: shop,
                        onCallPhone: controller.makePhoneCall,
                        onDirections: controller.openDirections,
                      ),
                    ),
                    const DetailDivider(),
                    KeyedSubtree(
                      key: _reviewsKey,
                      child: ShopDetailReviewsSection(
                        reviews: controller.reviews,
                        averageRating: controller.averageRating,
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
