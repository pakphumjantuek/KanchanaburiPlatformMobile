import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/routes/app_routes.dart';
import 'package:projecte/features/admin/theme/admin_colors.dart';
import '../../controllers/admin_dashboard_controller.dart';
import '../../models/admin_dashboard_model.dart';
import 'widgets/admin_sales_trend_chart.dart';
import 'package:projecte/shared/widgets/back_to_home_button.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int _selectedTab =
      0; // 0: ภาพรวม (Overview), 1: งานรอจัดการ (Action Radar), 2: ระบบบริการ (All Services)
  int _slideDirection = 1; // 1: เลื่อนไปข้างหน้า (ขวา), -1: ย้อนกลับ (ซ้าย)
  double _dragDistance = 0.0;
  int _selectedFeed = 0; // 0: ออเดอร์ล่าสุด, 1: ร้านค้ายอดนิยม

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadDashboard();
    });
  }

  void _switchTab(int newIndex) {
    if (newIndex == _selectedTab || newIndex < 0 || newIndex > 2) return;
    setState(() {
      _slideDirection = newIndex > _selectedTab ? 1 : -1;
      _selectedTab = newIndex;
    });
  }

  AdminDashboardController get controller {
    if (!Get.isRegistered<AdminDashboardController>()) {
      return Get.put(AdminDashboardController());
    }
    return Get.find<AdminDashboardController>();
  }

  void _showDateFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final fromDate = controller.selectedFromDate.value;
        final isAllTime = fromDate.isEmpty;
        int daysDiff = 0;
        if (!isAllTime) {
          final parsed = DateTime.tryParse(fromDate);
          if (parsed != null) {
            daysDiff = DateTime.now().difference(parsed).inDays;
          }
        }
        final is7Days = !isAllTime && daysDiff <= 10;
        final is30Days = !isAllTime && daysDiff > 10;

        return Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'เลือกช่วงเวลาแสดงข้อมูล',
                style: GoogleFonts.krub(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AdminColors.textPrimary,
                ),
              ),
              const SizedBox(height: 14),
              _filterTile(
                title: '7 วันล่าสุด (Past 7 Days) — ค่าเริ่มต้น',
                subtitle: 'สรุปการดำเนินงานรอบสัปดาห์ล่าสุดและแนวโน้มการค้า',
                isSelected: is7Days,
                onTap: () {
                  final now = DateTime.now();
                  final from = now.subtract(const Duration(days: 7));
                  controller.selectedFromDate.value = from
                      .toIso8601String()
                      .split('T')
                      .first;
                  controller.selectedToDate.value = now
                      .toIso8601String()
                      .split('T')
                      .first;
                  controller.loadDashboard();
                  Navigator.pop(ctx);
                },
              ),
              _filterTile(
                title: '30 วันล่าสุด (Past 30 Days)',
                subtitle: 'ความเคลื่อนไหวและยอดขายในรอบเดือนปัจจุบัน',
                isSelected: is30Days,
                onTap: () {
                  final now = DateTime.now();
                  final from = now.subtract(const Duration(days: 30));
                  controller.selectedFromDate.value = from
                      .toIso8601String()
                      .split('T')
                      .first;
                  controller.selectedToDate.value = now
                      .toIso8601String()
                      .split('T')
                      .first;
                  controller.loadDashboard();
                  Navigator.pop(ctx);
                },
              ),
              _filterTile(
                title: 'ยอดสะสมทั้งหมด (All Time)',
                subtitle: 'แสดงข้อมูลทั้งหมดตั้งแต่เริ่มต้นเปิดระบบ',
                isSelected: isAllTime,
                onTap: () {
                  controller.selectedFromDate.value = '';
                  controller.selectedToDate.value = '';
                  controller.loadDashboard();
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _filterTile({
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: Material(
        color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
        onTap: onTap,
        title: Text(
          title,
          style: GoogleFonts.krub(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            fontSize: 14,
            color: isSelected ? const Color(0xFF1D4ED8) : AdminColors.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.krub(fontSize: 12, color: AdminColors.textSecondary),
        ),
        trailing: isSelected
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AdminColors.primary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'เลือกอยู่',
                  style: GoogleFonts.krub(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : null,
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.background,
      bottomNavigationBar: Obx(() {
        final totalAlerts =
            controller.livePendingSlipsCount.value +
            controller.livePendingPayoutsCount.value;
        return _buildBottomNavBar(totalAlerts);
      }),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => controller.loadDashboard(),
          color: AdminColors.primary,
          child: Obx(() {
            final isLoading =
                controller.isLoading.value && controller.report.value == null;
            if (isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AdminColors.primary),
              );
            }

            final report = controller.report.value;
            final summary = report?.summary;
            final alerts = report?.alerts;

            return CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // 1. Sleek Modern Header (No bulky old AppBar!)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        BackToHomeButton(
                          color: AdminColors.primary,
                          borderColor: AdminColors.border,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AdminColors.primary.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: AdminColors.primary.withValues(
                                          alpha: 0.2,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 6,
                                          height: 6,
                                          decoration: const BoxDecoration(
                                            color: AdminColors.secondary,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          'ระบบออนไลน์',
                                          style: GoogleFonts.krub(
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.bold,
                                            color: AdminColors.primaryDark,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      'เมืองกาญจน์ คอมเมิร์ซ',
                                      style: GoogleFonts.krub(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: AdminColors.textSecondary,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'แผงควบคุมผู้ดูแลระบบ',
                                  style: GoogleFonts.krub(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: AdminColors.textPrimary,
                                    letterSpacing: -0.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Action Buttons: Filter & Refresh
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _actionTextButton(
                              label: 'ช่วงเวลา',
                              onTap: () => _showDateFilterSheet(context),
                            ),
                            const SizedBox(width: 6),
                            _actionTextButton(
                              label: 'รีเฟรช',
                              onTap: () => controller.loadDashboard(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // 2. Velvet Hero Executive Card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildExecutiveHeroCard(summary, alerts),
                  ),
                ),

                // 3. Tab Body Content with Horizontal Swipe & Animated Transition
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: _buildActiveTabContent(report, summary, alerts),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 36)),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _actionTextButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6.5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AdminColors.border),
            boxShadow: [
              BoxShadow(
                color: AdminColors.primaryDark.withValues(alpha: 0.04),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Text(
            label,
            style: GoogleFonts.krub(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AdminColors.primary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(int totalAlerts) {
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(18, 0, 18, 10),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: AdminColors.primaryDark.withValues(alpha: 0.12),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: AdminColors.primaryDark.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            _bottomNavItem(index: 0, title: 'ภาพรวม'),
            const SizedBox(width: 4),
            _bottomNavItem(
              index: 1,
              title: 'งานรอจัดการ',
              badgeCount: totalAlerts > 0 ? totalAlerts : null,
            ),
            const SizedBox(width: 4),
            _bottomNavItem(index: 2, title: 'ระบบบริการ'),
          ],
        ),
      ),
    );
  }

  Widget _bottomNavItem({
    required int index,
    required String title,
    int? badgeCount,
  }) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _switchTab(index),
          borderRadius: BorderRadius.circular(19),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 4),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AdminColors.primaryDark, // Deep Forest Teal
                        AdminColors.primary, // Emerald River Teal
                      ],
                    )
                  : null,
              color: isSelected ? null : Colors.transparent,
              borderRadius: BorderRadius.circular(19),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AdminColors.primary.withValues(alpha: 0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      title,
                      style: GoogleFonts.krub(
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF64748B),
                        letterSpacing: isSelected ? -0.2 : 0,
                      ),
                    ),
                  ),
                ),
                if (badgeCount != null) ...[
                  const SizedBox(width: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 1.5,
                    ),
                    decoration: BoxDecoration(
                      color: AdminColors.accent,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: AdminColors.accent.withValues(alpha: 0.4),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                      border: Border.all(color: Colors.white, width: 1.2),
                    ),
                    child: Text(
                      '$badgeCount',
                      style: GoogleFonts.krub(
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- 1. Emerald River & Forest Teal Executive Hero Card ---
  Widget _buildExecutiveHeroCard(
    AdminDashboardSummary? summary,
    AdminDashboardAlerts? alerts,
  ) {
    final totalSales = summary?.totalSales ?? 0.0;
    final totalOrders = summary?.totalOrders ?? 0;
    final paidOrders = summary?.paidOrders ?? 0;
    final activeShops = summary?.activeShops ?? 0;

    final payRatio = totalOrders > 0
        ? (paidOrders / totalOrders).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
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
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AdminColors.secondary.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AdminColors.primaryDark.withValues(alpha: 0.28),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Label + Export shortcut (Clean, Formal, No casual icons)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'ยอดขายสะสมรวม (GMV)',
                  style: GoogleFonts.krub(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(
                      0xFFD1FAE5,
                    ), // Mint Tint, high contrast on dark teal
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => Get.toNamed(AppRoutes.adminExports),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Text(
                    'รายงาน',
                    style: GoogleFonts.krub(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Total Revenue Big Number (Pure White on Emerald Teal - 100% legibility)
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              '฿${totalSales.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
              style: GoogleFonts.krub(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.6,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Progress Ratio Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'ชำระแล้ว $paidOrders จาก $totalOrders รายการ',
                  style: GoogleFonts.krub(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFE2E8F0),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2.5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AdminColors.gold.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  '${(payRatio * 100).toStringAsFixed(0)}% สำเร็จ',
                  style: GoogleFonts.krub(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: AdminColors.gold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: payRatio,
              minHeight: 6,
              backgroundColor: Colors.white.withValues(alpha: 0.18),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AdminColors.secondary,
              ),
            ),
          ),

          const SizedBox(height: 16),
          Divider(height: 1, color: Colors.white.withValues(alpha: 0.15)),
          const SizedBox(height: 14),

          // Embedded Quick Power Actions (Clean White, No background color)
          Row(
            children: [
              Expanded(
                child: _heroPowerButton(
                  title: 'ตรวจสลิป',
                  value: '${controller.livePendingSlipsCount.value} รายการ',
                  onTap: () => Get.toNamed(AppRoutes.adminOrders),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _heroPowerButton(
                  title: 'โอนร้านค้า',
                  value: '${controller.livePendingPayoutsCount.value} ร้าน',
                  onTap: () => Get.toNamed(AppRoutes.adminPayouts),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _heroPowerButton(
                  title: 'ร้านค้า',
                  value: '$activeShops ร้าน',
                  onTap: () => Get.toNamed(AppRoutes.adminShops),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _heroPowerButton({
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.25),
              width: 1.0,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,
                  style: GoogleFonts.krub(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.88),
                  ),
                ),
              ),
              const SizedBox(height: 3),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  style: GoogleFonts.krub(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Active Tab Switcher Content with Horizontal Swipe & Animated Transitions ---
  Widget _buildActiveTabContent(
    AdminDashboardReport? report,
    AdminDashboardSummary? summary,
    AdminDashboardAlerts? alerts,
  ) {
    Widget content;
    if (_selectedTab == 0) {
      content = KeyedSubtree(
        key: const ValueKey(0),
        child: _buildOverviewTab(report, summary),
      );
    } else if (_selectedTab == 1) {
      content = KeyedSubtree(
        key: const ValueKey(1),
        child: _buildActionRadarTab(report, alerts, summary),
      );
    } else {
      content = KeyedSubtree(
        key: const ValueKey(2),
        child: _buildAllServicesTab(),
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragStart: (_) {
        _dragDistance = 0.0;
      },
      onHorizontalDragUpdate: (details) {
        _dragDistance += details.primaryDelta ?? 0.0;
      },
      onHorizontalDragEnd: (details) {
        final velocity = details.primaryVelocity ?? 0.0;
        // Swiped Left (negative delta or velocity) -> Advance to next tab
        if (velocity < -200 || _dragDistance < -60) {
          if (_selectedTab < 2) {
            _switchTab(_selectedTab + 1);
          }
        }
        // Swiped Right (positive delta or velocity) -> Back to previous tab
        else if (velocity > 200 || _dragDistance > 60) {
          if (_selectedTab > 0) {
            _switchTab(_selectedTab - 1);
          }
        }
        _dragDistance = 0.0;
      },
      onHorizontalDragCancel: () {
        _dragDistance = 0.0;
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 240),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) {
          final isIncoming =
              (child.key as ValueKey<int>?)?.value == _selectedTab;
          final beginOffset = isIncoming
              ? Offset(_slideDirection * 0.12, 0.0)
              : Offset(-_slideDirection * 0.12, 0.0);

          return SlideTransition(
            position: Tween<Offset>(
              begin: beginOffset,
              end: Offset.zero,
            ).animate(animation),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        child: content,
      ),
    );
  }

  // === TAB 0: ภาพรวม & ยอดขาย (Overview) ===
  Widget _buildOverviewTab(
    AdminDashboardReport? report,
    AdminDashboardSummary? summary,
  ) {
    final fromDate = controller.selectedFromDate.value;
    int currentDays = 7;
    if (fromDate.isNotEmpty) {
      final parsed = DateTime.tryParse(fromDate);
      if (parsed != null) {
        final diff = DateTime.now().difference(parsed).inDays;
        if (diff > 0) currentDays = diff;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Interactive Trend Chart System (100% Real data from API)
        AdminSalesTrendChart(
          data: report?.salesTrend ?? const [],
          selectedDays: currentDays,
          onRangeChanged: (days) {
            final now = DateTime.now();
            final from = now.subtract(Duration(days: days));
            controller.selectedFromDate.value = from
                .toIso8601String()
                .split('T')
                .first;
            controller.selectedToDate.value = now
                .toIso8601String()
                .split('T')
                .first;
            controller.loadDashboard();
          },
        ),
        const SizedBox(height: 16),

        // 2. Segmented Feed Selector (Recent Orders vs Top Shops)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: AdminColors.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AdminColors.border),
              ),
              child: Row(
                children: [
                  _feedTogglePill(index: 0, title: 'คำสั่งซื้อล่าสุด'),
                  _feedTogglePill(index: 1, title: 'ร้านค้ายอดนิยม'),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                if (_selectedFeed == 0) {
                  Get.toNamed(AppRoutes.adminOrders);
                } else {
                  Get.toNamed(AppRoutes.adminShops);
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: AdminColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              child: Text(
                'ดูทั้งหมด →',
                style: GoogleFonts.krub(
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Feed List Card
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AdminColors.border),
            boxShadow: [
              BoxShadow(
                color: AdminColors.primaryDark.withValues(alpha: 0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: _selectedFeed == 0
              ? _buildRecentOrdersList(report?.recentOrders ?? [])
              : _buildTopShopsList(report?.topShops ?? []),
        ),
      ],
    );
  }

  Widget _feedTogglePill({required int index, required String title}) {
    final isSelected = _selectedFeed == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFeed = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AdminColors.primaryDark.withValues(alpha: 0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Text(
          title,
          style: GoogleFonts.krub(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected ? AdminColors.primary : AdminColors.textSecondary,
          ),
        ),
      ),
    );
  }

  String _translateOrderStatus(String status) {
    final s = status
        .trim()
        .toLowerCase()
        .replaceAll('_', '')
        .replaceAll(' ', '');
    switch (s) {
      case 'pending':
        return 'รอดำเนินการ';
      case 'pendingpayment':
        return 'รอชำระเงิน';
      case 'pendingverification':
        return 'รอตรวจสลิป';
      case 'confirmed':
        return 'ยืนยันแล้ว';
      case 'processing':
        return 'กำลังเตรียมสินค้า';
      case 'shipped':
        return 'จัดส่งแล้ว';
      case 'delivered':
        return 'จัดส่งสำเร็จ';
      case 'completed':
        return 'สำเร็จ';
      case 'cancelled':
      case 'canceled':
        return 'ยกเลิกแล้ว';
      case 'expired':
        return 'หมดอายุ';
      case 'refunded':
        return 'คืนเงินแล้ว';
      case 'paid':
        return 'ชำระแล้ว';
      default:
        return status;
    }
  }

  String _translatePaymentStatus(String status) {
    final s = status
        .trim()
        .toLowerCase()
        .replaceAll('_', '')
        .replaceAll(' ', '');
    switch (s) {
      case 'paid':
        return 'ชำระแล้ว';
      case 'pending':
        return 'รอชำระ';
      case 'pendingverification':
        return 'รอตรวจสลิป';
      case 'failed':
        return 'ไม่สำเร็จ';
      case 'cancelled':
      case 'canceled':
        return 'ยกเลิก';
      case 'refunded':
        return 'คืนเงินแล้ว';
      case 'rejected':
        return 'สลิปไม่ผ่าน';
      default:
        return status;
    }
  }

  Widget _buildRecentOrdersList(List<AdminRecentOrder> orders) {
    if (orders.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(28),
        child: Center(
          child: Text(
            'ไม่มีคำสั่งซื้อล่าสุดในระบบ',
            style: GoogleFonts.krub(
              fontSize: 13,
              color: AdminColors.textSecondary,
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: orders.length > 5 ? 5 : orders.length,
      separatorBuilder: (context, index) =>
          const Divider(height: 1, indent: 16, endIndent: 16),
      itemBuilder: (context, index) {
        final order = orders[index];
        final payNormalized = order.paymentStatus
            .trim()
            .toLowerCase()
            .replaceAll('_', '')
            .replaceAll(' ', '');
        final isPaid =
            payNormalized == 'paid' || order.paymentStatus.contains('ชำระ');
        final isPendingSlip =
            payNormalized == 'pendingverification' ||
            order.paymentStatus.contains('ตรวจสลิป');

        Color statusColor;
        Color badgeBg;
        if (isPaid) {
          statusColor = AdminColors.secondary;
          badgeBg = AdminColors.secondary.withValues(alpha: 0.1);
        } else if (isPendingSlip) {
          statusColor = const Color(0xFFD97706);
          badgeBg = const Color(0xFFFEF3C7);
        } else {
          statusColor = AdminColors.accent;
          badgeBg = AdminColors.accent.withValues(alpha: 0.1);
        }

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Get.toNamed(AppRoutes.adminOrders),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 36,
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '#${order.orderNumber}',
                              style: GoogleFonts.krub(
                                fontWeight: FontWeight.bold,
                                fontSize: 13.5,
                                color: AdminColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                '• ${order.shopName}',
                                style: GoogleFonts.krub(
                                  fontSize: 12,
                                  color: AdminColors.textSecondary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'สถานะ: ${_translateOrderStatus(order.orderStatus)}',
                          style: GoogleFonts.krub(
                            fontSize: 11,
                            color: AdminColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '฿${order.totalAmount.toStringAsFixed(2)}',
                          style: GoogleFonts.krub(
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            color: AdminColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: badgeBg,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _translatePaymentStatus(order.paymentStatus),
                          style: GoogleFonts.krub(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopShopsList(List<AdminTopShop> shops) {
    if (shops.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(28),
        child: Center(
          child: Text(
            'ไม่มีข้อมูลร้านค้ายอดนิยมในรอบนี้',
            style: GoogleFonts.krub(
              fontSize: 13,
              color: AdminColors.textSecondary,
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: shops.length > 5 ? 5 : shops.length,
      separatorBuilder: (context, index) =>
          const Divider(height: 1, indent: 16, endIndent: 16),
      itemBuilder: (context, index) {
        final shop = shops[index];
        final rank = index + 1;

        Color rankColor = const Color(0xFF8B7AA8);
        Color rankBg = const Color(0xFFF7F5FC);
        if (rank == 1) {
          rankColor = const Color(0xFFB58105);
          rankBg = const Color(0xFFFFF4D4);
        } else if (rank == 2) {
          rankColor = const Color(0xFF5E6D7E);
          rankBg = const Color(0xFFE9EEF4);
        } else if (rank == 3) {
          rankColor = const Color(0xFFB8592C);
          rankBg = const Color(0xFFFBECE4);
        }

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Get.toNamed(AppRoutes.adminShops),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: rankBg,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '$rank',
                        style: GoogleFonts.krub(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: rankColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          shop.shopName,
                          style: GoogleFonts.krub(
                            fontWeight: FontWeight.bold,
                            fontSize: 13.5,
                            color: AdminColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${shop.paidOrders} ออเดอร์ที่ชำระแล้ว',
                          style: GoogleFonts.krub(
                            fontSize: 11.5,
                            color: AdminColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '฿${shop.sales.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                      style: GoogleFonts.krub(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AdminColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // === TAB 1: งานรอจัดการ (Action Radar) ===
  Widget _buildActionRadarTab(
    AdminDashboardReport? report,
    AdminDashboardAlerts? alerts,
    AdminDashboardSummary? summary,
  ) {
    final pendingSlips = controller.livePendingSlipsCount.value;
    final pendingPayouts = controller.livePendingPayoutsCount.value;

    final totalUrgent = pendingSlips + pendingPayouts;

    return Column(
      children: [
        if (totalUrgent == 0)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F2FE),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'สถานะปกติ 100%',
                    style: GoogleFonts.krub(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0284C7),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'ทุกรายการเรียบร้อยสมบูรณ์',
                  style: GoogleFonts.krub(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AdminColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'ไม่มีสลิปตกค้าง และไม่มียอดโอนค้างจ่าย',
                  style: GoogleFonts.krub(
                    fontSize: 12.5,
                    color: AdminColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else ...[
          _radarActionCard(
            title: 'สลิปรอการตรวจสอบและยืนยัน',
            subtitle: 'ลูกค้าอัปโหลดสลิป รอการอนุมัติเพื่อดำเนินคำสั่งซื้อ',
            count: pendingSlips,
            color: AdminColors.accent,
            bgTint: AdminColors.accent.withValues(alpha: 0.1),
            onTap: () => Get.toNamed(AppRoutes.adminOrders),
          ),
          const SizedBox(height: 12),
          _radarActionCard(
            title: 'ร้านค้ารอโอนยอดเงิน (Payouts)',
            subtitle: 'คำสั่งซื้อสำเร็จ รอแอดมินดำเนินการโอนเงินให้ร้านค้า',
            count: pendingPayouts,
            color: AdminColors.primary,
            bgTint: AdminColors.primary.withValues(alpha: 0.1),
            onTap: () => Get.toNamed(AppRoutes.adminPayouts),
          ),
        ],
      ],
    );
  }

  Widget _radarActionCard({
    required String title,
    required String subtitle,
    required int count,
    required Color color,
    required Color bgTint,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: count > 0
                  ? color.withValues(alpha: 0.3)
                  : const Color(0xFFE0EAE6),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: count > 0
                    ? color.withValues(alpha: 0.06)
                    : const Color(0x060D2B22),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 42,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.krub(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.5,
                        color: AdminColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: GoogleFonts.krub(
                        fontSize: 11.5,
                        color: AdminColors.textSecondary,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: count > 0 ? color : const Color(0xFFEBF2EE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$count',
                  style: GoogleFonts.krub(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: count > 0 ? Colors.white : AdminColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // === TAB 2: ระบบจัดการทั้งหมด (All Services) ===
  Widget _buildAllServicesTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _serviceGroup(
          groupTitle: 'การเงิน & ตรวจสอบบัญชี',
          items: [
            _ServiceItem(
              title: 'ตรวจสอบสลิปการโอน',
              desc: 'อนุมัติการชำระเงินของลูกค้า',
              color: AdminColors.accent,
              route: AppRoutes.adminOrders,
            ),
            _ServiceItem(
              title: 'สั่งจ่ายเงินร้านค้า (Payouts)',
              desc: 'โอนเงินรอบรายได้ให้พาร์ทเนอร์ร้านค้า',
              color: AdminColors.primary,
              route: AppRoutes.adminPayouts,
            ),
            _ServiceItem(
              title: 'ส่งออกข้อมูลและรายงาน',
              desc: 'ดาวน์โหลดไฟล์ CSV/Excel วิเคราะห์ผล',
              color: const Color(0xFF2A9D8F),
              route: AppRoutes.adminExports,
            ),
          ],
        ),

        const SizedBox(height: 16),

        _serviceGroup(
          groupTitle: 'ร้านค้า & สินค้าชุมชน',
          items: [
            _ServiceItem(
              title: 'อนุมัติและจัดการร้านค้า',
              desc: 'ตรวจสอบใบสมัครและสถานะร้าน',
              color: const Color(0xFF3D6B82),
              route: AppRoutes.adminShops,
            ),
            _ServiceItem(
              title: 'โครงสร้างหมวดหมู่สินค้า',
              desc: 'เพิ่ม/แก้ไขประเภทสินค้าในระบบ',
              color: const Color(0xFFD97724),
              route: AppRoutes.adminCategories,
            ),
            _ServiceItem(
              title: 'จัดการแท็กการค้นหา',
              desc: 'คีย์เวิร์ดช่วยค้นหาและ SEO',
              color: const Color(0xFF7C4DFF),
              route: AppRoutes.adminTags,
            ),
          ],
        ),

        const SizedBox(height: 16),

        _serviceGroup(
          groupTitle: 'การท่องเที่ยว & สื่อชุมชน',
          items: [
            _ServiceItem(
              title: 'บทความและเนื้อหาท่องเที่ยว',
              desc: 'ไฮไลต์ที่เที่ยว รีวิว วิดีโอแนะนำ',
              color: const Color(0xFF4A7C59),
              route: AppRoutes.adminContents,
            ),
            _ServiceItem(
              title: 'ตารางกิจกรรมและเทศกาล',
              desc: 'ปฏิทินงานประจำปีเมืองกาญจน์',
              color: const Color(0xFF2B7DE9),
              route: AppRoutes.adminSchedules,
            ),
            _ServiceItem(
              title: 'ศูนย์รับเรื่องร้องเรียน',
              desc: 'ปัญหาการสั่งซื้อและข้อเสนอแนะ',
              color: const Color(0xFFE63946),
              route: AppRoutes.adminReports,
            ),
          ],
        ),
      ],
    );
  }

  Widget _serviceGroup({
    required String groupTitle,
    required List<_ServiceItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            groupTitle,
            style: GoogleFonts.krub(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AdminColors.textSecondary,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE0EAE6)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x050D2B22),
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            clipBehavior: Clip.antiAlias,
            child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) =>
                const Divider(height: 1, indent: 24, endIndent: 16),
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                onTap: () => Get.toNamed(item.route),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                leading: Container(
                  width: 4,
                  height: 32,
                  decoration: BoxDecoration(
                    color: item.color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                title: Text(
                  item.title,
                  style: GoogleFonts.krub(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5,
                    color: AdminColors.textPrimary,
                  ),
                ),
                subtitle: Text(
                  item.desc,
                  style: GoogleFonts.krub(
                    fontSize: 11.5,
                    color: AdminColors.textSecondary,
                  ),
                ),
                trailing: Text(
                  'เข้าใช้งาน',
                  style: GoogleFonts.krub(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AdminColors.primary,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    ],
  );
}
}

class _ServiceItem {
  final String title;
  final String desc;
  final Color color;
  final String route;

  _ServiceItem({
    required this.title,
    required this.desc,
    required this.color,
    required this.route,
  });
}
