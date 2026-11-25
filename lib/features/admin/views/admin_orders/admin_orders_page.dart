import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/admin/theme/admin_colors.dart';
import '../../controllers/admin_orders_controller.dart';
import 'widgets/admin_orders_empty_state.dart';
import 'widgets/admin_slip_group_card.dart';

class AdminOrdersPage extends GetView<AdminOrdersController> {
  const AdminOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AdminOrdersController>()) {
      Get.put(AdminOrdersController());
    }

    final searchController = TextEditingController(text: controller.searchQuery.value);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: RefreshIndicator(
          color: AdminColors.primary,
          onRefresh: () => controller.loadPendingSlips(),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // 1. Executive Summary & Search Panel
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Subtitle Description Banner
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          gradient: AdminColors.headerGradient,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: AdminColors.primaryDark.withValues(alpha: 0.15),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.verified_user_rounded,
                                color: AdminColors.secondary,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Admin Slip Verification',
                                    style: GoogleFonts.krub(
                                      color: AdminColors.secondary,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'ตรวจสอบสลิปโอนเงินเข้าบัญชีกลาง',
                                    style: GoogleFonts.krub(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'ตรวจเช็คยอดเงินและสลิปหลักฐานก่อนอนุมัติให้ร้านค้าเริ่มจัดส่ง',
                                    style: GoogleFonts.krub(
                                      color: Colors.white.withValues(alpha: 0.8),
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Live KPI Summary Bar
                      Obx(() => _buildKpiSummaryBar()),

                      const SizedBox(height: 14),

                      // Search Bar
                      _buildSearchBar(searchController),
                    ],
                  ),
                ),
              ),

              // 2. Slip Cards List / Skeleton / Empty State
              Obx(() {
                if (controller.isLoading.value && controller.pendingSlips.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(color: AdminColors.primary),
                          const SizedBox(height: 14),
                          Text(
                            'กำลังดึงข้อมูลสลิปที่รอตรวจสอบ...',
                            style: GoogleFonts.krub(
                              fontSize: 13,
                              color: AdminColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final list = controller.filteredSlips;

                if (controller.pendingSlips.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: AdminOrdersEmptyState(
                      onRefresh: () => controller.loadPendingSlips(),
                    ),
                  );
                }

                if (list.isEmpty && controller.searchQuery.value.isNotEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.search_off_rounded,
                              size: 48,
                              color: Color(0xFF94A3B8),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'ไม่พบรายการสลิปที่ค้นหา',
                              style: GoogleFonts.krub(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AdminColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'คำค้น "${controller.searchQuery.value}" ไม่ตรงกับชื่อผู้ซื้อ เบอร์โทร หรือเลขออเดอร์ใดๆ',
                              style: GoogleFonts.krub(
                                fontSize: 12.5,
                                color: AdminColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            TextButton.icon(
                              onPressed: () {
                                searchController.clear();
                                controller.searchQuery.value = '';
                              },
                              icon: const Icon(Icons.clear_rounded, size: 16),
                              label: const Text('ล้างคำค้นหา'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final group = list[index];
                        return AdminSlipGroupCard(
                          controller: controller,
                          group: group,
                          index: index,
                        );
                      },
                      childCount: list.length,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  // --- AppBar ---
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      foregroundColor: AdminColors.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: false,
      title: Text(
        'ตรวจสอบสลิปการชำระเงิน',
        style: GoogleFonts.krub(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: AdminColors.textPrimary,
        ),
      ),
      actions: [
        Obx(() => IconButton(
              tooltip: 'รีเฟรชข้อมูล',
              icon: controller.isLoading.value
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AdminColors.primary,
                      ),
                    )
                  : const Icon(Icons.refresh_rounded, color: AdminColors.primary),
              onPressed: controller.isLoading.value
                  ? null
                  : () => controller.loadPendingSlips(),
            )),
        const SizedBox(width: 8),
      ],
    );
  }

  // --- KPI Summary Bar ---
  Widget _buildKpiSummaryBar() {
    final pendingCount = controller.pendingSlips.length;
    final totalAmount = controller.totalPendingAmount;
    final ordersCount = controller.totalPendingOrdersCount;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x050D2B22),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Pending Slips
          Expanded(
            child: _buildKpiMetric(
              label: 'รอตรวจสอบ',
              value: '$pendingCount สลิป',
              icon: Icons.pending_actions_rounded,
              color: const Color(0xFFD97706),
            ),
          ),
          Container(height: 30, width: 1, color: const Color(0xFFE2E8F0)),
          // Total Amount
          Expanded(
            child: _buildKpiMetric(
              label: 'ยอดเงินรวม',
              value: '฿${totalAmount.toStringAsFixed(2)}',
              icon: Icons.account_balance_wallet_rounded,
              color: AdminColors.primaryDark,
            ),
          ),
          Container(height: 30, width: 1, color: const Color(0xFFE2E8F0)),
          // Total Orders
          Expanded(
            child: _buildKpiMetric(
              label: 'ออเดอร์รวม',
              value: '$ordersCount คำสั่งซื้อ',
              icon: Icons.shopping_bag_outlined,
              color: AdminColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiMetric({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, size: 12, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: GoogleFonts.krub(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: AdminColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: GoogleFonts.krub(
                fontSize: 13.5,
                fontWeight: FontWeight.bold,
                color: color,
                letterSpacing: -0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Search Bar ---
  Widget _buildSearchBar(TextEditingController searchController) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: TextField(
        controller: searchController,
        style: GoogleFonts.krub(fontSize: 13, color: AdminColors.textPrimary),
        onChanged: (val) => controller.searchQuery.value = val,
        decoration: InputDecoration(
          hintText: 'ค้นหาชื่อผู้ซื้อ, เบอร์โทร, เลขออเดอร์...',
          hintStyle: GoogleFonts.krub(fontSize: 12.5, color: const Color(0xFF94A3B8)),
          prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF94A3B8), size: 20),
          suffixIcon: Obx(() => controller.searchQuery.value.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, size: 18, color: Color(0xFF94A3B8)),
                  onPressed: () {
                    searchController.clear();
                    controller.searchQuery.value = '';
                  },
                )
              : const SizedBox.shrink()),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
    );
  }
}
