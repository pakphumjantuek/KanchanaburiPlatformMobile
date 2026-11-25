import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:projecte/features/admin/controllers/admin_shops_controller.dart';
import 'package:projecte/features/admin/theme/admin_colors.dart';
import 'widgets/manage_shops_filter_panel.dart';
import 'widgets/manage_shops_list.dart';

class ManageShopsPage extends GetView<AdminShopsController> {
  const ManageShopsPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AdminShopsController>()) {
      Get.put(AdminShopsController());
    }

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

              // 2. Pending Approval Alert Banner (if any)
              _buildPendingNoticeBanner(),

              // 3. Search and Status Filter Panel
              ManageShopsFilterPanel(controller: controller),

              // 4. Shop Cards List with Pagination
              Expanded(
                child: ManageShopsList(controller: controller),
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
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'จัดการและอนุมัติร้านค้า',
            style: GoogleFonts.krub(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          Text(
            'ตรวจสอบ อนุมัติ และควบคุมสถานะร้านค้าในระบบ',
            style: GoogleFonts.krub(
              fontSize: 11,
              color: Colors.white.withValues(alpha: 0.75),
              fontWeight: FontWeight.w400,
            ),
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

        final total = controller.totalShopsCount.value;
        final pending = controller.pendingCount.value;
        final active = controller.activeCount.value;

        return Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                title: 'ร้านค้าทั้งหมด',
                value: '$total',
                subText: 'ร้านในระบบ',
                icon: Icons.storefront_rounded,
                iconColor: const Color(0xFF38BDF8),
                bgColor: Colors.white.withValues(alpha: 0.1),
                onTap: () => controller.selectStatus(''),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildMetricCard(
                title: 'รอการอนุมัติ',
                value: '$pending',
                subText: pending > 0 ? 'รอตรวจสอบ' : 'เรียบร้อย',
                icon: Icons.pending_actions_rounded,
                iconColor: const Color(0xFFFBBF24),
                bgColor: pending > 0
                    ? const Color(0xFFF59E0B).withValues(alpha: 0.22)
                    : Colors.white.withValues(alpha: 0.1),
                highlightBorder: pending > 0,
                onTap: () => controller.selectStatus('Pending'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildMetricCard(
                title: 'เปิดใช้งาน',
                value: '$active',
                subText: 'พร้อมจำหน่าย',
                icon: Icons.verified_rounded,
                iconColor: const Color(0xFF34D399),
                bgColor: Colors.white.withValues(alpha: 0.1),
                onTap: () => controller.selectStatus('Active'),
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
                  ? const Color(0xFFFBBF24).withValues(alpha: 0.6)
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
                      ? const Color(0xFFFDE68A)
                      : Colors.white.withValues(alpha: 0.65),
                  fontWeight: highlightBorder ? FontWeight.w600 : FontWeight.w400,
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


  Widget _buildPendingNoticeBanner() {
    return Obx(() {
      final pending = controller.pendingCount.value;
      if (pending == 0) return const SizedBox.shrink();

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: const Color(0xFFFFFBEB),
        child: Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Color(0xFFD97706),
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'มีร้านค้าใหม่ $pending ร้าน กำลังรอการอนุมัติเปิดบริการ',
                style: GoogleFonts.krub(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFB45309),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            InkWell(
              onTap: () => controller.selectStatus('Pending'),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                child: Text(
                  'ดูร้านค้า',
                  style: GoogleFonts.krub(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFB45309),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

