import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/admin/theme/admin_colors.dart';
import 'package:projecte/features/admin/controllers/admin_payouts_controller.dart';
import 'widgets/admin_pending_payout_card.dart';
import 'widgets/admin_payout_history_card.dart';
import 'widgets/admin_payouts_tab_bar.dart';
import 'widgets/admin_payouts_empty_state.dart';

class AdminPayoutsPage extends StatefulWidget {
  const AdminPayoutsPage({super.key});

  @override
  State<AdminPayoutsPage> createState() => _AdminPayoutsPageState();
}

class _AdminPayoutsPageState extends State<AdminPayoutsPage> {
  final TextEditingController _searchController = TextEditingController();

  AdminPayoutsController get controller {
    if (!Get.isRegistered<AdminPayoutsController>()) {
      return Get.put(AdminPayoutsController());
    }
    return Get.find<AdminPayoutsController>();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // 1. Executive Summary Metric Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: _buildMetricBanner(),
                ),
              ),

              // 2. Search & Filter Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildSearchBar(),
                ),
              ),

              // 3. Tab Switcher
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 4),
                  child: AdminPayoutsTabBar(controller: controller),
                ),
              ),

              // 4. Content List
              Obx(() {
                if (controller.isLoading.value &&
                    controller.pendingPayouts.isEmpty &&
                    controller.payoutHistory.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(color: AdminColors.primaryLight),
                    ),
                  );
                }

                if (controller.activeTab.value == 0) {
                  final pending = controller.filteredPendingPayouts;
                  if (pending.isEmpty) {
                    final isSearch = controller.searchQuery.value.isNotEmpty;
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: AdminPayoutsEmptyState(
                        message: isSearch ? 'ไม่พบร้านค้าที่ตรงกับคำค้นหา' : 'ไม่มีรายการรอโอนเงินในขณะนี้',
                        subMessage: isSearch
                            ? 'ลองเปลี่ยนคำค้นหาเป็นชื่อร้าน เลขบัญชี หรือพร้อมเพย์'
                            : 'ยอดเงินร้านค้าทั้งหมดได้รับการโอนเรียบร้อยสมบูรณ์',
                        icon: isSearch ? Icons.search_off_rounded : Icons.check_circle_outline_rounded,
                        onRefresh: () => controller.loadData(),
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => AdminPendingPayoutCard(
                          controller: controller,
                          payout: pending[index],
                        ),
                        childCount: pending.length,
                      ),
                    ),
                  );
                } else {
                  final history = controller.filteredHistory;
                  if (history.isEmpty) {
                    final isSearch = controller.searchQuery.value.isNotEmpty;
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: AdminPayoutsEmptyState(
                        message: isSearch ? 'ไม่พบข้อมูลที่ตรงกับคำค้นหา' : 'ยังไม่มีประวัติการโอนเงิน',
                        subMessage: isSearch ? 'ลองตรวจสอบรหัสอ้างอิงหรือชื่อร้านค้าใหม่อีกครั้ง' : null,
                        icon: isSearch ? Icons.search_off_rounded : Icons.history_rounded,
                        onRefresh: () => controller.loadData(),
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => AdminPayoutHistoryCard(record: history[index]),
                        childCount: history.length,
                      ),
                    ),
                  );
                }
              }),
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
          child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: Colors.white),
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'โอนเงินให้ร้านค้า',
            style: GoogleFonts.krub(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: Colors.white,
            ),
          ),
          Text(
            'Merchant Payouts Management',
            style: GoogleFonts.krub(
              fontSize: 11,
              color: const Color(0xFFBAE6FD),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () => controller.loadData(),
          icon: Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.refresh_rounded, size: 18, color: Colors.white),
          ),
          tooltip: 'รีเฟรชข้อมูล',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildMetricBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AdminColors.primaryDark,
            AdminColors.primary,
            Color(0xFF1E40AF),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AdminColors.secondary.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AdminColors.primaryDark.withValues(alpha: 0.25),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Obx(() {
        final totalAmount = controller.totalPendingAmount;
        final pendingCount = controller.pendingPayouts.length;
        final totalOrders = controller.totalPendingOrders;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'ยอดรวมรอโอนทั้งหมด',
                    style: GoogleFonts.krub(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFBAE6FD),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: pendingCount > 0 ? const Color(0xFFE76F51) : const Color(0xFF0284C7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    pendingCount > 0 ? '$pendingCount ร้านค้าค้างโอน' : 'โอนครบทุกร้านแล้ว',
                    style: GoogleFonts.krub(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                '฿${totalAmount.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                style: GoogleFonts.krub(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.6,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Divider(height: 1, color: Colors.white.withValues(alpha: 0.15)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _metricSubItem(
                    icon: Icons.storefront_rounded,
                    label: 'ร้านค้ารอโอน',
                    value: '$pendingCount ร้านค้า',
                  ),
                ),
                Container(
                  height: 24,
                  width: 1,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
                Expanded(
                  child: _metricSubItem(
                    icon: Icons.shopping_bag_outlined,
                    label: 'ออเดอร์สะสม',
                    value: '$totalOrders รายการ',
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }

  Widget _metricSubItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 16, color: const Color(0xFFBAE6FD)),
        const SizedBox(width: 6),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: GoogleFonts.krub(
                  fontSize: 10.5,
                  color: const Color(0xFFBAE6FD),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                value,
                style: GoogleFonts.krub(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: AdminColors.primaryDark.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (val) => controller.updateSearchQuery(val),
        style: GoogleFonts.krub(fontSize: 13.5),
        decoration: InputDecoration(
          hintText: 'ค้นหาชื่อร้านค้า, ธนาคาร, เลขบัญชี, พร้อมเพย์...',
          hintStyle: GoogleFonts.krub(fontSize: 12.5, color: AdminColors.textSecondary),
          prefixIcon: const Icon(Icons.search_rounded, size: 20, color: AdminColors.primary),
          suffixIcon: Obx(() {
            if (controller.searchQuery.value.isEmpty) return const SizedBox.shrink();
            return IconButton(
              icon: const Icon(Icons.clear_rounded, size: 18, color: AdminColors.textSecondary),
              onPressed: () {
                _searchController.clear();
                controller.updateSearchQuery('');
              },
            );
          }),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
    );
  }
}
