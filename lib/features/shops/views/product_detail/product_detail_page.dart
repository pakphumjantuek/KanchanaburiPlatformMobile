import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecte/app/theme/app_colors.dart';
import 'package:projecte/features/shops/controllers/product_detail_controller.dart';
import 'package:projecte/features/shops/models/product_model.dart';
import 'package:projecte/features/shops/views/product_detail/widgets/product_detail_bottom_bar.dart';
import 'package:projecte/features/shops/views/product_detail/widgets/product_detail_gallery.dart';
import 'package:projecte/features/shops/views/product_detail/widgets/product_detail_info_panel.dart';
import 'package:projecte/features/shops/views/product_detail/widgets/product_detail_seller_card.dart';
import 'package:projecte/features/shops/views/product_detail/widgets/product_detail_tabs.dart';
import 'package:projecte/shared/widgets/error_widget.dart';
import 'package:projecte/shared/widgets/loading_widget.dart';

class ProductDetailPage extends GetView<ProductDetailController> {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        final product = controller.product.value;
        final sellerShop = controller.sellerShop.value;

        if (controller.isLoading.value && product == null) {
          return const Center(
            child: LoadingWidget(message: 'กำลังโหลดข้อมูลสินค้า...'),
          );
        }

        if (product == null) {
          return Center(
            child: CustomErrorWidget(
              message: 'ไม่พบรายละเอียดสินค้าในระบบ',
              onRetry: () {
                final args = Get.arguments;
                if (args != null) {
                  controller.loadProductAndShop(
                    args is String ? args : (args as ProductModel).id,
                    null,
                  );
                }
              },
            ),
          );
        }

        final images = <String>[
          if (product.imageUrl?.trim().isNotEmpty == true)
            product.imageUrl!.trim(),
          ...product.detailImages.where(
            (image) =>
                image.trim().isNotEmpty && image.trim() != product.imageUrl,
          ),
        ];

        return RefreshIndicator(
          onRefresh: () =>
              controller.loadProductAndShop(product.id, product.shopId),
          color: AppColors.primary,
          child: SafeArea(
            bottom: false,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                // 1. Image Gallery with back and favorite buttons
                SliverToBoxAdapter(
                  child: ProductDetailGallery(product: product, images: images),
                ),

                // 2. Main Product Info & Pricing Panel
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
                    child: ProductDetailInfoPanel(
                      product: product,
                      shop: sellerShop,
                    ),
                  ),
                ),

                // 3. Seller Merchant Card
                if (sellerShop != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                      child: ProductDetailSellerCard(shop: sellerShop),
                    ),
                  ),

                // 4. Navigation Tabs (Details vs Reviews)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: ProductDetailNavTabs(),
                  ),
                ),

                // 5. Active Tab Content
                SliverToBoxAdapter(
                  child: Obx(() {
                    if (controller.activeTab.value == 'reviews') {
                      return ProductReviewsTabContent(
                        reviews: controller.shopReviews,
                      );
                    }
                    return ProductDetailsTabContent(product: product);
                  }),
                ),

                // Bottom spacer for comfortable scrolling
                const SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            ),
          ),
        );
      }),
      bottomNavigationBar: const ProductDetailBottomBar(),
    );
  }
}
