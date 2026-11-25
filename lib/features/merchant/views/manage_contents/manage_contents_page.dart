import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:projecte/app/routes/app_routes.dart';
import 'package:projecte/features/merchant/controllers/manage_contents_controller.dart';
import 'package:projecte/features/merchant/theme/merchant_colors.dart';
import 'package:projecte/features/merchant/views/manage_contents/widgets/manage_content_card.dart';
import 'package:projecte/features/merchant/views/manage_contents/widgets/manage_contents_empty_state.dart';
import 'package:projecte/features/merchant/views/manage_contents/widgets/manage_contents_hero.dart';
import 'package:projecte/features/merchant/views/manage_contents/widgets/manage_contents_search_field.dart';
import 'package:projecte/shared/widgets/loading_widget.dart';

class ManageContentsPage extends GetView<ManageContentsController> {
  const ManageContentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ManageContentsController>()) {
      Get.put(ManageContentsController());
    }

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
              'จัดการเรื่องราว & ข่าวสาร',
              style: GoogleFonts.krub(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Colors.white,
              ),
            ),
            Text(
              'Merchant Stories & Articles',
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
            onPressed: controller.loadContents,
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Get.toNamed(AppRoutes.myShopContentForm);
          if (result == true) controller.loadContents();
        },
        backgroundColor: MerchantColors.primary,
        foregroundColor: Colors.white,
        elevation: 6,
        icon: const Icon(Icons.add_circle_outline_rounded, size: 22),
        label: Text(
          'เขียนเรื่องราวใหม่',
          style: GoogleFonts.krub(
            fontWeight: FontWeight.bold,
            fontSize: 13.5,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget(message: 'กำลังโหลดเรื่องราวและข่าวสาร...');
        }

        final contents = controller.filteredContents;

        return RefreshIndicator(
          onRefresh: () => controller.loadContents(),
          color: MerchantColors.primary,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              // Top Hero Banner & Interactive KPI Metrics
              SliverToBoxAdapter(
                child: ManageContentsHero(controller: controller),
              ),

              // Search Bar & Filter Chips
              SliverToBoxAdapter(
                child: ManageContentsSearchField(controller: controller),
              ),

              // Main Contents List or Empty State
              if (contents.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: ManageContentsEmptyState(
                    isShopNull: controller.myShop.value == null,
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = contents[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: ManageContentCard(item: item),
                        );
                      },
                      childCount: contents.length,
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
