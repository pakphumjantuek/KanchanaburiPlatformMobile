import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/merchant/controllers/merchant_dashboard_controller.dart';
import 'package:projecte/features/merchant/theme/merchant_colors.dart';
import 'package:projecte/shared/widgets/loading_widget.dart';
import 'widgets/merchant_action_radar_tab.dart';
import 'widgets/merchant_dashboard_hero_card.dart';
import 'widgets/merchant_kpi_overview_tab.dart';
import 'widgets/merchant_services_directory_tab.dart';
import 'package:projecte/shared/widgets/back_to_home_button.dart';

class MerchantDashboardPage extends StatefulWidget {
  const MerchantDashboardPage({super.key});

  @override
  State<MerchantDashboardPage> createState() => _MerchantDashboardPageState();
}

class _MerchantDashboardPageState extends State<MerchantDashboardPage> {
  int _selectedTab = 0; // 0: ภาพรวม (Overview), 1: งานรอจัดการ (Action Radar), 2: ระบบบริการ (Services)
  int _slideDirection = 1; // 1: forward (right), -1: backward (left)
  double _dragDistance = 0.0;

  MerchantDashboardController get controller {
    if (!Get.isRegistered<MerchantDashboardController>()) {
      return Get.put(MerchantDashboardController());
    }
    return Get.find<MerchantDashboardController>();
  }

  void _switchTab(int newIndex) {
    if (newIndex == _selectedTab || newIndex < 0 || newIndex > 2) return;
    setState(() {
      _slideDirection = newIndex > _selectedTab ? 1 : -1;
      _selectedTab = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MerchantColors.background,
      bottomNavigationBar: Obx(() {
        final totalAlerts = controller.totalAlertsCount;
        return _buildBottomNavBar(totalAlerts);
      }),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.refreshData,
          color: MerchantColors.primary,
          child: Obx(() {
            if (controller.isLoading.value && controller.report.value == null) {
              return const LoadingWidget(
                message: 'กำลังโหลดข้อมูลแดชบอร์ดร้านค้า...',
              );
            }

            final shop = controller.myShop.value;
            final report = controller.report.value;

            return CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                // 1. Sleek Modern Header (No bulky old AppBar)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        BackToHomeButton(
                          color: MerchantColors.primary,
                          borderColor: MerchantColors.border,
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
                                      color: MerchantColors.primary.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: MerchantColors.primary.withValues(
                                          alpha: 0.25,
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
                                            color: MerchantColors.primaryLight,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          shop?.status == 'Active'
                                              ? 'ร้านเปิดบริการ'
                                              : 'สถานะร้านค้า',
                                          style: GoogleFonts.krub(
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.bold,
                                            color: MerchantColors.primaryDark,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      shop?.name ?? 'ผู้ประกอบการชุมชน',
                                      style: GoogleFonts.krub(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: MerchantColors.textSecondary,
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
                                  'แผงควบคุมร้านค้า',
                                  style: GoogleFonts.krub(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: MerchantColors.textPrimary,
                                    letterSpacing: -0.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Action Button: Refresh with Spinner
                        _actionRefreshButton(),
                      ],
                    ),
                  ),
                ),

                // 2. Velvet Hero Executive Card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: MerchantDashboardHeroCard(
                      shop: shop,
                      report: report,
                    ),
                  ),
                ),

                // 3. Tab Body Content with Horizontal Swipe & Animated Transition
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: _buildActiveTabContent(shop, report),
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

  Widget _actionRefreshButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: controller.isRefreshing.value ? null : () => controller.refreshData(),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6.5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: MerchantColors.border),
            boxShadow: [
              BoxShadow(
                color: MerchantColors.primaryDark.withValues(alpha: 0.04),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (controller.isRefreshing.value) ...[
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: MerchantColors.primary,
                  ),
                ),
                const SizedBox(width: 6),
              ] else ...[
                const Icon(
                  Icons.refresh_rounded,
                  size: 15,
                  color: MerchantColors.primary,
                ),
                const SizedBox(width: 4),
              ],
              Text(
                'รีเฟรช',
                style: GoogleFonts.krub(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: MerchantColors.primary,
                ),
              ),
            ],
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
              color: MerchantColors.primaryDark.withValues(alpha: 0.12),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: MerchantColors.primaryDark.withValues(alpha: 0.04),
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
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? MerchantColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(19),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: GoogleFonts.krub(
                    fontSize: 12.5,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    color: isSelected ? Colors.white : MerchantColors.textSecondary,
                  ),
                ),
                if (badgeCount != null && badgeCount > 0) ...[
                  const SizedBox(width: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : MerchantColors.warning,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      badgeCount > 99 ? '99+' : '$badgeCount',
                      style: GoogleFonts.krub(
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? MerchantColors.warning : Colors.white,
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

  Widget _buildActiveTabContent(dynamic shop, dynamic report) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragUpdate: (details) {
        _dragDistance += details.primaryDelta ?? 0;
      },
      onHorizontalDragEnd: (details) {
        if (_dragDistance < -45) {
          // Swipe left -> go forward
          _switchTab(_selectedTab + 1);
        } else if (_dragDistance > 45) {
          // Swipe right -> go backward
          _switchTab(_selectedTab - 1);
        }
        _dragDistance = 0.0;
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 240),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) {
          final inOffset = Tween<Offset>(
            begin: Offset(_slideDirection * 0.25, 0),
            end: Offset.zero,
          ).animate(animation);

          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: inOffset,
              child: child,
            ),
          );
        },
        child: KeyedSubtree(
          key: ValueKey<int>(_selectedTab),
          child: _renderCurrentTab(shop, report),
        ),
      ),
    );
  }

  Widget _renderCurrentTab(dynamic shop, dynamic report) {
    switch (_selectedTab) {
      case 1:
        return MerchantActionRadarTab(report: report);
      case 2:
        return MerchantServicesDirectoryTab(shop: shop);
      case 0:
      default:
        return MerchantKpiOverviewTab(shop: shop, report: report);
    }
  }
}
