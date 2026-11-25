import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/app/routes/app_routes.dart';
import 'package:projecte/shared/widgets/loading_widget.dart';
import 'package:projecte/features/merchant/controllers/manage_products_controller.dart';
import 'package:projecte/features/merchant/theme/merchant_colors.dart';
import 'package:projecte/features/merchant/views/manage_products/widgets/manage_product_card.dart';
import 'package:projecte/features/merchant/views/manage_products/widgets/manage_products_empty_state.dart';
import 'package:projecte/features/merchant/views/manage_products/widgets/manage_products_kpi_banner.dart';
import 'package:projecte/features/merchant/views/manage_products/widgets/manage_products_search_field.dart';

class ManageProductsPage extends GetView<ManageProductsController> {
  const ManageProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ManageProductsController>()) {
      Get.put(ManageProductsController());
    }
    controller.checkAndUpdateFilter();

    return Scaffold(
      backgroundColor: MerchantColors.background,
      appBar: AppBar(
        backgroundColor: MerchantColors.primaryDark,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 16,
              color: Colors.white,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'คลังสินค้าในร้าน',
              style: GoogleFonts.krub(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Colors.white,
              ),
            ),
            Text(
              'Merchant Inventory Hub',
              style: GoogleFonts.krub(
                fontSize: 11,
                color: const Color(0xFFA7F3D0),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'รีเฟรชข้อมูล',
            icon: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.refresh_rounded,
                size: 18,
                color: Colors.white,
              ),
            ),
            onPressed: () => controller.loadProducts(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (controller.myShop.value == null) {
            Get.toNamed(AppRoutes.registerShop);
          } else {
            final result = await Get.toNamed(AppRoutes.myShopProductForm);
            if (result == true) controller.loadProducts();
          }
        },
        backgroundColor: MerchantColors.primary,
        foregroundColor: Colors.white,
        elevation: 6,
        icon: const Icon(Icons.add_shopping_cart_rounded, size: 22),
        label: Text(
          'เพิ่มสินค้าใหม่',
          style: GoogleFonts.krub(
            fontWeight: FontWeight.bold,
            fontSize: 13.5,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget(message: 'กำลังโหลดรายการสินค้าในคลัง...');
        }

        final list = controller.filteredProducts;

        return RefreshIndicator(
          onRefresh: () => controller.loadProducts(),
          color: MerchantColors.primary,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              // Top Executive Hero Header & KPI Banner
              SliverToBoxAdapter(
                child: ManageProductsKpiBanner(controller: controller),
              ),

              // Search Bar & Filter Chips
              ManageProductsSearchField(controller: controller),

              // Main Product List or Empty State
              if (list.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: ManageProductsEmptyState(controller: controller),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = list[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ManageProductCard(
                            controller: controller,
                            product: product,
                          ),
                        );
                      },
                      childCount: list.length,
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
