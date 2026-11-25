import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/app/routes/app_routes.dart';
import 'package:projecte/features/merchant/controllers/manage_orders_controller.dart';
import 'package:projecte/features/merchant/theme/merchant_colors.dart';
import 'package:projecte/features/merchant/views/manage_orders/widgets/manage_order_card.dart';
import 'package:projecte/features/merchant/views/manage_orders/widgets/manage_orders_filter_tabs.dart';
import 'package:projecte/features/merchant/views/manage_orders/widgets/manage_orders_kpi_banner.dart';
import 'package:projecte/features/merchant/views/manage_orders/widgets/manage_orders_search_bar.dart';
import 'package:projecte/shared/widgets/loading_widget.dart';

class ManageOrdersPage extends GetView<ManageOrdersController> {
  const ManageOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ManageOrdersController>()) {
      Get.put(ManageOrdersController());
    }
    controller.checkAndUpdateStatusTab();

    return Scaffold(
      backgroundColor: MerchantColors.background,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Column(
          children: [
            // 1. KPI Metric Summary Banner (Tap to filter)
            ManageOrdersKpiBanner(controller: controller),

            // 2. Real-time Search Bar
            ManageOrdersSearchBar(controller: controller),

            // 3. Status Filter Tabs with Live Count Badges
            ManageOrdersFilterTabs(controller: controller),

            // 4. Orders List / Empty State / Loading State
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.orders.isEmpty) {
                  return const LoadingWidget(
                    message: 'กำลังโหลดรายการคำสั่งซื้อ...',
                  );
                }

                final list = controller.filteredOrders;
                final isSearching = controller.searchQuery.value.trim().isNotEmpty;
                final selectedStatus = controller.selectedStatus.value;
                final hasStatusFilter = selectedStatus != 'All' && selectedStatus.isNotEmpty;

                if (list.isEmpty) {
                  return Center(
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 76,
                            height: 76,
                            decoration: BoxDecoration(
                              color: MerchantColors.primaryDark.withValues(alpha: 0.06),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isSearching
                                  ? Icons.search_off_rounded
                                  : hasStatusFilter
                                      ? Icons.filter_alt_off_rounded
                                      : controller.myShop.value == null
                                          ? Icons.storefront_outlined
                                          : Icons.assignment_outlined,
                              size: 38,
                              color: MerchantColors.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            isSearching
                                ? 'ไม่พบคำสั่งซื้อที่ตรงกับ "${controller.searchQuery.value}"'
                                : hasStatusFilter
                                    ? 'ไม่มีคำสั่งซื้อในสถานะที่เลือก'
                                    : controller.myShop.value == null
                                        ? 'ยังไม่ได้ลงทะเบียนร้านค้า'
                                        : 'ยังไม่มีคำสั่งซื้อเข้ามาในขณะนี้',
                            style: GoogleFonts.krub(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: MerchantColors.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            isSearching
                                ? 'ลองตรวจสอบคำค้นหา เลขคำสั่งซื้อ หรือชื่อผู้รับใหม่อีกครั้ง'
                                : hasStatusFilter
                                    ? 'คุณสามารถเลือกดูสถานะอื่น หรือดูรายการคำสั่งซื้อทั้งหมด'
                                    : controller.myShop.value == null
                                        ? 'กรุณากรอกข้อมูลลงทะเบียนร้านค้าเพื่อเปิดใช้งานและรับออเดอร์'
                                        : 'เมื่อลูกค้าสั่งซื้อและชำระเงิน รายการจะแสดงผลเรียงตามเวลาในหน้านี้',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.krub(
                              fontSize: 12.5,
                              color: MerchantColors.textSecondary,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (isSearching || hasStatusFilter)
                            ElevatedButton.icon(
                              onPressed: () {
                                controller.clearSearch();
                                controller.changeStatusTab('All');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: MerchantColors.primary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: const Icon(Icons.refresh_rounded, size: 16),
                              label: Text(
                                'ล้างการค้นหาและตัวกรอง',
                                style: GoogleFonts.krub(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          else if (controller.myShop.value == null)
                            ElevatedButton.icon(
                              onPressed: () => Get.toNamed(AppRoutes.registerShop),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD97706),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 0,
                              ),
                              icon: const Icon(Icons.edit_document, size: 18),
                              label: Text(
                                'ลงทะเบียนร้านค้าใหม่',
                                style: GoogleFonts.krub(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.loadOrders,
                  color: MerchantColors.primary,
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 32),
                    itemCount: list.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final order = list[index];
                      return ManageOrderCard(
                        controller: controller,
                        order: order,
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  'จัดการคำสั่งซื้อ',
                  style: GoogleFonts.krub(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                decoration: BoxDecoration(
                  color: MerchantColors.primaryLight.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  'ORDERS',
                  style: GoogleFonts.robotoMono(
                    fontSize: 9.5,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF6EE7B7),
                  ),
                ),
              ),
            ],
          ),
          Text(
            'ตรวจสอบคำสั่งซื้อ ยืนยันการชำระเงิน และอัปเดตการจัดส่ง',
            style: GoogleFonts.krub(
              fontSize: 10.5,
              color: Colors.white.withValues(alpha: 0.75),
              fontWeight: FontWeight.w400,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      actions: [
        Obx(
          () => IconButton(
            icon: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: controller.isLoading.value
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(
                      Icons.refresh_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
            ),
            tooltip: 'รีเฟรชคำสั่งซื้อ',
            onPressed: () => controller.loadOrders(),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
