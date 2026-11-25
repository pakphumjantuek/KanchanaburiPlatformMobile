import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:projecte/features/admin/controllers/admin_products_controller.dart';
import 'package:projecte/features/admin/theme/admin_colors.dart';
import 'package:projecte/features/shops/models/shop_model.dart';
import 'widgets/manage_products_list.dart';
import 'widgets/manage_products_status_filter.dart';

class AdminManageProductsPage extends StatefulWidget {
  const AdminManageProductsPage({super.key});

  @override
  State<AdminManageProductsPage> createState() =>
      _AdminManageProductsPageState();
}

class _AdminManageProductsPageState extends State<AdminManageProductsPage> {
  late final AdminProductsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<AdminProductsController>();
    final shop = Get.arguments;
    if (shop is ShopModel) {
      controller.setShop(shop.shopId, shop.shopName, model: shop);
    } else {
      controller.setShop('', '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.background,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: RefreshIndicator(
          color: AdminColors.primaryLight,
          onRefresh: () => controller.loadData(),
          child: Column(
            children: [
              // 1. Executive Metric Summary Banner
              _buildMetricBanner(),

              // 2. Search & Status Filter Panel
              ManageProductsStatusFilter(controller: controller),

              // 3. Products List with Pagination
              Expanded(
                child: ManageProductsList(controller: controller),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AdminColors.primaryDark,
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
      title: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.shopName.value.isNotEmpty
                  ? 'สินค้าในร้าน: ${controller.shopName.value}'
                  : 'จัดการสินค้าในร้านค้า',
              style: GoogleFonts.krub(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'ควบคุมสถานะการวางจำหน่าย ตรวจสอบราคา และคลังสินค้า',
              style: GoogleFonts.krub(
                fontSize: 11,
                color: Colors.white.withValues(alpha: 0.75),
                fontWeight: FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
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
            tooltip: 'รีเฟรชข้อมูล',
            onPressed: () => controller.loadData(),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildMetricBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: const BoxDecoration(
        gradient: AdminColors.headerGradient,
      ),
      child: Obx(() {
        final total = controller.totalProductsCount.value;
        final active = controller.activeCount.value;
        final inactive = controller.inactiveCount.value;

        return Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                title: 'สินค้าทั้งหมด',
                value: '$total',
                subText: 'รายการในร้าน',
                icon: Icons.inventory_2_outlined,
                iconColor: const Color(0xFF38BDF8),
                bgColor: Colors.white.withValues(alpha: 0.1),
                onTap: () => controller.selectStatus(''),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildMetricCard(
                title: 'เปิดจำหน่าย',
                value: '$active',
                subText: 'พร้อมขาย',
                icon: Icons.check_circle_outline_rounded,
                iconColor: const Color(0xFF34D399),
                bgColor: Colors.white.withValues(alpha: 0.1),
                onTap: () => controller.selectStatus('Active'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildMetricCard(
                title: 'ระงับการขาย',
                value: '$inactive',
                subText: inactive > 0 ? 'งดจำหน่าย' : 'ไม่มี',
                icon: Icons.block_rounded,
                iconColor: const Color(0xFFF87171),
                bgColor: inactive > 0
                    ? const Color(0xFFEF4444).withValues(alpha: 0.22)
                    : Colors.white.withValues(alpha: 0.1),
                highlightBorder: inactive > 0,
                onTap: () => controller.selectStatus('Inactive'),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subText,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required VoidCallback onTap,
    bool highlightBorder = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: highlightBorder
                  ? const Color(0xFFF87171).withValues(alpha: 0.6)
                  : Colors.white.withValues(alpha: 0.15),
              width: highlightBorder ? 1.5 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.krub(
                        fontSize: 10.5,
                        color: Colors.white.withValues(alpha: 0.85),
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(icon, size: 14, color: iconColor),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.krub(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 1),
              Text(
                subText,
                style: GoogleFonts.krub(
                  fontSize: 9.5,
                  color: highlightBorder
                      ? const Color(0xFFFECACA)
                      : Colors.white.withValues(alpha: 0.65),
                  fontWeight:
                      highlightBorder ? FontWeight.w600 : FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

